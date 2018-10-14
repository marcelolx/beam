# Beam
A microservice used in [oorja](https://github.com/akshayKMR/oorja) for soft-realtime messaging between room participants and relaying important events that happen at the backend.

> This service is written in elixir using the phoenix framework.

### Why make a microservice?
- oorja needed a realtime messaging functionality between room participants. Elixir felt like the perfect tool I could use for this purpose. It's fault tolerant, highly availabile and distributed. You get a lot of stuff for free.
- Phoenix framework can also track user presence using distributed pubsub.
- Performance: Initial version of oorja used to watch mongodb oplog for any updates to the `Room` documents and then used to push the changeset to the room participants. It is how pub/sub works in a meteor app. However cpu usage grows with the number of subscriptions. Now the backend knows when a room document has changed since it is solely responsible for it, so instead of watching the db for changes, the backend now hits Beam to broadcast an event that the *room document is updated*. Anyone subscribed to the room channel can fetch the updates when they recieve such an event. So in effect pub/sub cpu usage went down


### Running the app
- [Install Elixir](https://elixir-lang.org/install.html)
- In the project root
  - Install dependencies with `mix deps.get`
  - Start Phoenix endpoint with `mix phx.server`

The service should now be running at port `5000`.

  

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
