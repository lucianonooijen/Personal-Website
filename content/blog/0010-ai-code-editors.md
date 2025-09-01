+++
date = "2025-04-01"
title = "Why I stopped using AI code editors"
slug = "why-i-stopped-using-ai-code-editors"
tags = ["AI"]
categories = ["Tools"]
[params]
  metadescription = "In the past I used AI code editors for all of my programming, but I stopped using it and recommend others to consider this as well"
  metakeywords = 'ai, code editors, llm, vibe coding'
+++

_TL;DR: I chose to make using AI a manual action, because I felt the slow loss of competence over time when I relied on it, and I recommend everyone to be cautious with making AI a key part of their workflow._

In late 2022, I used AI tools for the first time, even before the first version of ChatGPT. In 2023, I started using AI-based tools in my development workflow. Initially, I was super impressed with the capabilities of these LLMs. The fact that I could just copy and paste obscure compiler errors along with the C++ source code, and be told where the error is caused felt like magic.

Once GitHub Copilot started becoming more and more powerful, I started using it more and more. I used various other LLM integrations right in my editor. Using AI was part of my workflow.

In late 2024 I removed all LLM integrations from my code editors. I still use LLMs occasionally and I do think AI can be used in a way that is very beneficial for many programmers. So then why don't I use AI-powered code editing tools?

## Tesla FSD

From 2019 to 2021 I drove a Tesla. Though I would never make the same purchase again, not for political reasons, just because the cars are quite low quality, very overpriced and a hell to repair or maintain.

When I got my Tesla, I started using the Full Self-Driving (FSD) anytime I could. It felt great to just put the car on FSD on the highway and zone out a bit. Switching lanes was as simple as hitting the turn signal, and the car would switch lanes. Driving for me was just getting to the highway, turning on FSD, telling the car to switch lanes every now and then, and listen to music/podcasts while zoning out.

If you drive a car often, you'll know that when you're driving on the highway, everything sort of happens automatically. Keeping your car in the lane at the right speed becomes a passive action, it does not require the type of focus that for example reading a book requires, it's the type of focus that walking requires, it happens in the background of your mind.

In the period from 2019 to 2021 I exclusively drove my Tesla for longer rides. After 2021, I went back to driving regular cars and making this switch was definitely not what I expected. Driving on the highway required my full attention for the first month or so, I had to re-learn keeping the car in the middle of the lane without thinking about it.

Being reliant on Tesla's FSD took away my own ability to go into autopilot.

## My experience with AI code editors

Working with AI-powered code editors was somewhat similar. Initially, I felt that I completed work a lot faster when assisted by AI. The work I was doing most of the time was not super complex, and AI felt like putting my Tesla on FSD, I could just guide the machine to do my work for me.

In my free time, I started working on a side project on my personal account on my work device. On this account, I did not have access to Copilot and my other cool, fancy AI tools. This is when using AI started to feel very similar to my Tesla FSD story.

I felt less competent at doing what was quite basic software development than a year or so before. All of a sudden, it made it very clear to me how reliant I had become on AI tools. Anytime I defined a function, I paused in my editor to wait until the AI tools would write the implementation for me. It took some effort to remember what the syntax was to write unit tests by hand.

With my work, AI started to become less useful over time as well. Not only did it take out the fun for me, but I started to feel a bit insecure about making some implementation decisions myself. Outsourcing the decisions to the AI seemed a lot easier. But sometimes, the AI couldn't figure things out, even with the best prompts. It was quite clear that because I did not practice the basics often, I was less capable with the harder parts as well.

## The loss of Fingerspitzengefühl

> **_Fingerspitzengefühl_** \[ˈfɪŋɐˌʃpɪtsənɡəˌfyːl\] is a German term, literally meaning _"finger tips feeling"_ and meaning intuitive flair or instinct, which has been adopted by the English language as a loanword. It describes a great situational awareness, and the ability to respond most appropriately and tactfully. [^fsg]

[^fsg]: Source: [Wikipedia](https://en.wikipedia.org/wiki/Fingerspitzengef%C3%BChl)

Defining seniority is a very tough thing. Though in my opinion a lot of being a "senior" is in soft-skills, when it comes to the technical hard-skills, a lot comes down to Fingerspitzengefühl. The longer you work with a language, framework or codebase, the more you develop this kind of intuition of what the correct approach is. The gut feeling of "something feels off" slowly turns into a feeling of "this is what we should do".

This developed intuition is not just on an architectural level. A big component is in the lower level details, when to use pointers (or what type of pointers), whether to use asserts or checks, what to pick from the standard library when multiple options are available (though senior C++ programmers still can't seem to agree on this).

This intuition is what I was slowly losing when relying on AI tools a lot. And this is coming from a lead developer. When I see a lot of hype about vibe coding, I can't help but think: how do you exactly expect to vibe code your way to senior? Where will you get the skills from to maintain and extend the vibe-coded codebase when the AI tools are down, or have become too expensive?

Even with larger context windows, more computing power, reasoning models or agents, there will be things that AI won't be able to do. Over time, the AI tools will be more and more powerful, sure. But when you receive a Slack message that "the website works fine, but the app is down in production; I tried it locally and there it works fine, nothing in Sentry either", good luck getting an AI agent to fix this for you. Maybe it can, maybe it can't. And when an AI agent can't figure it out, will your reply be "sorry, Cursor doesn't get it, will prompt more tomorrow"?

## You can get by without these tools

Sometimes it feels like you have to use AI or be out of a job in 6 months. We've been hearing the "3-6 months from now"-story for over two years at this point. I stopped trusting CEO promises about functionality "3-6 months from now" years ago. When I got my Tesla in 2019, I paid €6400 for functionality that was supposed to arrive in "3-6 months from now", and the functionality is still not present the way it was promised over 5 years ago.

Right now, it is unlikely that letting AI do your coding will work for projects larger than a university project. When working on legacy systems or larger projects in enterprises or when you need to work with and consult a lot of dependency internals (like I do with Unreal Engine), AI tools will often not be able to make things work. When you need to work with internal DSLs, tools or frameworks, good luck getting LLMs to generate useful output. For some industries, you can't even use AI tools at all for a multitude of reasons.

For some things you really should not _want_ to rely on AI. When implementing authentication systems like JWT[^jwt] signing or RBAC[^rbac], adding "and it should be secure" to the prompt won't make it secure if it's been trained on GitHub code that had CVEs[^cve]. When it comes to security, you should be the person who is responsible and understands this fully. Critical systems should be written and reviewed by humans, if we are heading to a situation where one AI agent writes the code, another reviews the autogenerated PR and then another AI agent deploys the code, we will see a huge spike of security issues soon.

[^jwt]: JSON Web Tokens, or JWTs are a common way to generate authentication tokens, among other uses

[^rbac]: Role-based access control (RBAC) is a mechanism to restrict system access by setting permissions and privileges

[^cve]: Common Vulnerabilities and Exposures (CVE) is a program used to identify, define and catalog publicly disclosed cybersecurity vulnerabilities, [cve.org](https://www.cve.org/)

## Where I draw the line

I still use AI, sometimes. I think it can be a great tool, when used wisely. I draw the line at integration. I keep AI fully separate from my code editor. All of the context, I add manually. I intentionally keep the effort required quite high, so it disincentivizes me.

Examples where I use AI for work include "convert these Go tests in structs to tests in a map", "convert this calculation to SIMD", or "when the content type is application/zlib, decode the body"[^aiworkexamples]. I have set up some custom instructions to only give me the code that has changed, and give me instructions for adding it. This way, I am still the one making the changes in the codebase. Just approving a Git diff is not enough, I want to manually add the code myself, only then do I feel confident to sign off on it and take responsibility for it.

[^aiworkexamples]: The specific contents here don't matter that much, they are just examples of what I use AI for

Another great use case for AI is learning. I often have questions that are quite uncommon, as I have a few very niche interests. Turns out, adding netcode to a custom game engine using ECS doesn't have a lot of learning resources. What has worked for me, is asking AI to explain pieces of code, like "explain this assembly code", "explain what this shader does", "which books go in-depth about resolving client/server desyncs in game engines". The AI seems to struggle with these sometimes, I'm getting mixed results, but the results are still much better than search engines. I will even use it for this article, though not for writing content, but for checking[^checkprompt].

[^checkprompt]: The prompt I've used for this article: "I want you to proofread an article I have written. I want you to give me feedback on incorrect grammar or broken sentences, using UK grammar. Do not comment on sentences that should be broken up or things that could be improved just slightly, only real errors. Do not return modified sentences, but point out where the issue is, under which paragraph, in which sentence and what the mistake is. I will make the required changes myself". It came back with a few typos, like "form" that should be "from", "eb" that should be "be".

Another benefit of using AI this way is the cost. No unnecessary API calls, manually managed contexts and more control over the LLM settings. I use a desktop application with a bunch of different LLMs hooked up to it. I have used it daily for the last 3 months or so, and in total, I have consumed around $4 in credits.

I do want to add that with some things I am more strict. On my personal website, I don't want any AI-generated content, whether that's text or images. I don't like AI generated images or 'art' personally for various reasons and I think AI-generated text lacks character, it feels very flat and boring. When something is created by humans, it to me has more value than when it's created by AI.

## Doing what you love

It is also worth noting that there are more things to think about than efficiency and productivity. It's also about doing what you love. If you love coding, keep doing it yourself, even if a computer might be better at it.

In 1997, Deep Blue won the chess match against the then world chess champion Garry Kasparov[^deepblue], yet people still play chess. When it comes to programming, I'd say that I program for the same reason that people still play chess[^chessclip]. Though chess and software development are very different, with chess being much more limited in scope, I think it is good to keep in mind that sometimes, we can do things just to enjoy them.

[^deepblue]: Source: [IBM History](https://www.ibm.com/history/deep-blue)

[^chessclip]: Source: [Tsoding on YouTube](https://youtu.be/-eS5-kaTSD0?si=Mf3ySN8QbpWhgLgK&t=328)

## My advice to new programmers

Don't become a forever junior who lets AI do all their work. If you want to become a programmer, learn to program yourself. Be curious, put in the time and effort to learn how things really work, and how things work in the layer below that. It really pays off. Learning how everything works under the hood and using that is amazing, just keep learning, don't be a prompt engineer (if you can even call that engineering). Believe me, it's more fun to be competent[^funcompetent].

[^funcompetent]: Source: [DHH in an interview on YouTube](https://youtu.be/mTa2d3OLXhg?si=vfjLD1DeoPZMERxA&t=1126)

Even though AI might be smarter than you, never blindly trust the AI output. Don't build your whole workflow around it. Sometimes try to work without it for a few days. The better at programming you are, the more AI will get in your way for the more complex work.

If you learn to code now, keep building your skills instead of letting AI do all the heavy lifting, you'll be capable of fixing the messes that vibe coding is now creating. I don't want to sound elitist, but if you don't want to learn to go beyond vibe coding, maybe coding isn't for you. Because positions where all work can be done by vibe coding are the ones that will be eliminated first when AI becomes more powerful.

And remember: if you cannot code without AI, you cannot code.

## Conclusion

When you are using AI, you are sacrificing knowledge for speed. Sometimes it's worth making this trade-off. Though it is important to remember that even the best athletes in the world are still doing their basic drills for a reason. The same applies to software development: you need to practice the basics, to be able to do the advanced work. You need to keep your axe sharp.

We are still a long way out from AI taking over our jobs. A lot of companies are creating FOMO[^fomo] as a sales tactic to get more customers, to show traction to their investors, to get another round of funding, to generate the next model that will definitely revolutionize everything.

[^fomo]: Fear of missing out

AI is a tool, it is not good or bad in itself, it's what you do with it. I do think it can be a great tool, as long as you are not reliant on it for your workflow. Make sure you can still work effectively without it, make sure you don't push code to production that you don't fully understand and don't think of AI as a replacement for your own thinking. Stay curious, keep learning.
