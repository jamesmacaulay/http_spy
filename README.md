# HttpSpy

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

[HttpSpy](https://httpspy.herokuapp.com) is a (work-in-progress) HTTP request capturer/logger/debugger. It is a lot like the lovely [RequestBin](https://requestb.in), with a few noteworthy differences:

  * You see requests in real time!
  * It is built with [Elixir](http://elixir-lang.org/), [Phoenix](http://www.phoenixframework.org/), and [Elm](http://elm-lang.org/)
  * No persistence layer
  * Requests are irretrievable once you close the browser tab (for now)
  * URLs can't be private (for now)

## Developing

  1. [Install Elixir](http://elixir-lang.org/install.html)
  2. Go to the root of this project and install dependencies with `mix deps.get`
  3. Start up a Phoenix dev server with `mix phoenix.server`
  4. Visit [`localhost:4000`](http://localhost:4000) in your browser
