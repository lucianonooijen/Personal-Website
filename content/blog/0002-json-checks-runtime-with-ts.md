+++
date = "2020-08-24"
title = "Runtime JSON typechecks with Typescript interfaces"
slug = "runtime-json-typechecks-with-typescript-interfaces"
tags = ["Typescript", "Code Generation"]
categories = ["Frontend"]
[params]
  metadescription = 'How to add runtime typechecks for JSON in Typescript'
  metakeywords = 'typescript, json, typechecking'
+++

_The contents of this article are technical in nature and mainly written for software developers_

Bytecode is currently working on a project for a startup. We are developing an app that is linked to a backend data storage service. For this project, I wanted to have more security around the API calls and validate the types at runtime.

## Background

At Bytecode, we use Typescript extensively for front-end and mobile development, to prevent Javascript's liberal dynamic typing system from causing errors. Typescript adds an extra layer of security. In recent years, we have seen a strong decrease in type-related errors due to the use of Typescript.

However, Typescript also has it's limitations, the main one being that types and interfaces disappear during compile-time. So there are no run-time checks on external data that is not available during compilation, like for example API responses. Ideally, Typescript would support marshalling in a way [similar to Go](https://medium.com/rungo/working-with-json-in-go-7e3a37c5a07b), to secure type safety during runtime. Unfortunately, however, the Typescript layer disappears during compile-time and only Javascript remains: code that knows nothing about the types and interfaces defined in the source code. Unfortunately, the Go-like approach would never be possible using features built into the language.

Until recently, we did our API calls directly within Redux actions, which didn't cause any problems for small applications. However, this setup is not the best, considering the [single-responsibility principle](https://en.wikipedia.org/wiki/Single-responsibility_principle) and keeping in mind that Redux actions can get confusing with large projects, if you're not careful. This is why we recently switched to creating separate API packages as an abstraction layer on top of the API calls. We now only call a function that executes the API calls and checks HTTP errors. If there are no errors, we'll get the data back. If there are errors, an error is thrown. This way, the Redux code does not know anything about the details of the API call.

Another reason to use a separate API package, is our desire to be able to set up an SDK more easily later on, when we start targeting another platform (think of an application, first only web, but where a mobile app will be added as well). It will then be possible to use shared code easily, without duplicate logic. Since these API packages become increasingly important with more dependent applications, the run-time guarantees also get more crucial. If the SDK says that a function returns a certain data type, we also want to guarantee this or else give an error message.

## Requirements and research

Our research question consisted of several parts:

- How can we generically check a JSON object against a Typescript interface, without the need for duplicate code for type definitions?
- How can we achieve the above without having to modify other production code outside the API package to make this check possible?
- How can this be done in NodeJS, React Native and in the browser?

There are enough libraries that make it possible to check a JSON structure, based on a DSL (domain specific language). However, this wasn't what we were looking for, because we were already using Typescript and didn't want to maintain the same type definition in multiple ways. We would prefer to develop a solution where no code generation or extra step in compilation is needed, but everything on-the-fly during runtime (like Go).

A few months ago, I read a [blog post by Picnic](https://blog.picnic.nl/guarding-a-react-native-application-from-evil-json-6f7cbb4404de), describing their project "Aegis", in which they had offered a solution to this problem. However, I noticed that it was still difficult to implement. The code is open source, but there was no example of implementation on a larger scale, because this was done within Picnic's proprietary app. A code generation step was also needed. We would, if possible, prefer not to have this extra step.

On the Subreddit of Typescript I had placed a [post](https://www.reddit.com/r/typescript/comments/i8yk6i/validating_objects_type_at_runtime/), where I submitted my question. I primarily received responses with examples of code generation solutions. Some responses discussed runtime solutions, but these solutions were unnecessarily complex and/or required modifications within the build configuration of Typescript. We prefer to avoid this, because we prefer to keep something experimental separate from the rest of our production code, so that if we are not satisfied, we can revert the changes.

A possible solution that popped into my head was the following:

- Load all type-definitions through the file system as strings
- Use the Typescript compiler as production dependency and parse these strings
- Compare the result of parsing against the JSON data to see if it matches the interfaces

However, this would mean that a substantial part of the Typescript compiler would have to become part of the app and thus increase the bundle size. The Typescript compiler is not the fastest in the world either, so this would take a considerable amount of extra time when it has to be done on-the-fly. In addition, the filesystem is only suitable for Node.js and not for browser environments, so compatibility could not be maintained. Unfortunately this solution was not feasible.

Ultimately, I chose to use [Picnic's Aegis](https://github.com/PicnicSupermarket/aegis), mainly because of the simplicity of the tool and because it can be used without modifying other aspects of the project (compilation steps, configurations or production code in other parts of the application).

## Implementation

The final implementation is as follows. Within the API folder, all public types (that is, the arguments and return types of the entire API package) are defined in the `types` folder. For all types in this folder, Aegis creates decoders and stores them in the `internal` folder of the API package.

In order to make the aforementioned solution usable for Bytecode, a few adjustments had to be made in Aegis. For example, we added ESLint comments at the top of the file. This was done in a [fork of Aegis](https://github.com/lucianonooijen/aegis/tree/bytecode) on Github. This is the dependency used in Bytecode's project. To build the decoders, a command has been added to the `package.json` of the React-Native/Expo project. By simply running `yarn run aegis`, Aegis is called with the right arguments and all decoders are built.

The production code of the API package already used an internal `returnOrThrow` function, which received an internal API response type (consisting of the response of the API and/or an error if it occurred), threw an error if it existed and otherwise returned the data. This function has been modified so that a second argument is given to the function, namely the decoder. In `returnOrThrow` the decoder is then used to check the data before it is returned. See the example below:

```ts
import { Decoder } from "decoders/types";
import { guard } from "decoders";

interface APIResultSuccess<T> {
  data: T;
  error?: undefined;
}
interface APIResultFailure {
  data?: undefined;
  error: string;
}
type APIResult<T> = APIResultSuccess<T> | APIResultFailure;

const throwOrReturn = <T>(result: APIResult<T>, decoder: Decoder<T>): T => {
  if (result.error) {
    throw new Error(result.error);
  }
  // We can assume that data is valid (type T) if no error was found
  const data = result.data as T;

  const decodeChecker = guard(decoder);
  const _ = decodeChecker(data); // Throws if it's not valid
  return data;
};

export default throwOrReturn;
```

If the return body does not satisfy the decoder, an error is thrown, which can be caught when calling the API call.

## Wishlist

For now, the implementation of JSON type checks is still experimental. Within the codebase, this type check only affects a small (separate) part, so it can be easily removed later on. This is why it is not automated yet, something we would like to add later on. Automating this without modifying the build configuration can still be a challenge. Until we automate this completely, we can add a check in the CI pipeline that gives an error message when running Aegis causes file changes in Git, meaning the decoders have not been updated after making changes to the type definitions.

Another very good use-case of this setup would be the end-to-end testing of the API for which the package is built. The end-to-end testing of APIs is something that has been on the Bytecode wishlist for some time now. JSON type checking can also provide great added value, allowing you to immediately check whether the API returns data according to the expectations.

Regarding improvement to Aegis itself, at the moment Aegis is mainly built for the "happy flow", there are still some edge cases that don't quite work. The tool is now definitely usable, but improvements are still needed for large-scale use.

Support for Aegis configuration files is another useful addition. Now arguments for `importPath` and `outputFile` must be given as CLI options. Simply calling `aegis generate`, which then loads the configuration by itself would be a nice addition.

If it turns out that this workflow works very well for Bytecode, there is a good chance that we will further develop the Aegis tool ourselves, open-source of course. For now, the tool is not yet available on NPM. That would be the first step towards a stable release.

## Example project

As an addition to this article, an example project is also available, with a simple API call, where the tool can be seen in action.

Check out the [project on Github](https://github.com/lucianonooijen/ts-runtime-json-checks-example).
