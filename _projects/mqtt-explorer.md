---
showcase: 7
title: MQTT Explorer
cover:
  description: MQTT Explorer is designed to make monitoring an MQTT bus easier by providing a lightweight app with topic subscriptions, monitoring of latest messages and publishing new messages.
tags:
  - iOS App
  - iPadOS App
  - macOS App
---

This was my first personal dive into iOS/macOS apps using SwiftUI, and while
it's not technically difficult, it was an interesting learning experience and
gave me my first real taste of Swift code and the SwiftUI framework.

The features in MQTT Explorer were driven by not feeling like I had the proper
tools at my disposal while debugging issues with my home automation setup,
which makes heavy use of an MQTT bus as the API for a wide variety of devices.
I wanted to be able to explore the topics of a bus in a hierarchical fashion,
pin certain topics so that their latest messages were always visible and have
easy access to a set of saved, recently sent and recently received messages to
publish.

## Screenshots
<div class="not-prose grid grid-cols-1 gap-x-8 gap-8 justify-center md:grid-cols-2">
  <div class="h-[600px]">
    {% include figure.html src="/assets/projects/mqtt-explorer/viewing-brokers.png" caption="" %}
  </div>
  <div class="h-[600px]">
    {% include figure.html src="/assets/projects/mqtt-explorer/editing-broker.png" caption="" %}
  </div>
  <div class="h-[600px]">
    {% include figure.html src="/assets/projects/mqtt-explorer/viewing-broker.png" caption="" %}
  </div>
  <div class="h-[600px]">
    {% include figure.html src="/assets/projects/mqtt-explorer/viewing-topics.png" caption="" %}
  </div>
  <div class="h-[600px]">
    {% include figure.html src="/assets/projects/mqtt-explorer/viewing-a-topics-messages.png" caption="" %}
  </div>
  <div class="h-[600px]">
    {% include figure.html src="/assets/projects/mqtt-explorer/viewing-a-topic-with-pins.png" caption="Pinning a topic allows quick access to it's most recent message while also allowing the viewing of other topics, which can be helpful when systems have a two or more topics that work in tandem." %}
  </div>
</div>

## Technology
- Swift 5.9
- [CocoaMQTT](https://github.com/emqx/CocoaMQTT)
