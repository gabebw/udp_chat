# Let's chat over UDP

Once upon a time, [@edwardloveall], being of a curious bent, decided to
investigate UDP messaging for a game. He shared this ambition with me and we
discovered Glenn Fiedler's excellent [Networking for Game Programmers] article
series.

I recommend Glenn's articles - he has a clear explanation of the differences
between TCP and UDP, and why TCP isn't appropriate for high-performance game
programming.

[@edwardloveall]: https://twitter.com/edwardloveall
[Networking for Game Programmers]: http://gafferongames.com/networking-for-game-programmers/udp-vs-tcp/

## Set up

First, bundle:

    bundle

Then copy `env.example` to `.env` and edit it. It's well-documented.

Now you can chat:

    ruby chat.rb

## OK, sure, but this isn't a game?

Yeah, fair question. We decided to implement person-to-person chat first, which
turned out to be more complicated than expected. But we ended up with `chat.rb`,
which has detailed (OSX-specific) instructions on how to find the appropriate IP
address and ports for setting up a computer-to-computer connection.

## Questions? Advice?

I'd describe my adventures in networking as "bumbling", so any advice is
appreciated. Is there a classic text? Or a good blog post? Send it to [@gabebw].

[@gabebw]: https://twitter.com/gabebw
