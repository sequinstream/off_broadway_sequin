# OffBroadwaySequin

A [Broadway](https://hexdocs.pm/broadway/introduction.html) producer implementation for [Sequin](https://sequin.io) consumer groups.

## Installation

Add `off_broadway_sequin` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:off_broadway_sequin, "~> 0.1.0"}
  ]
end
```

## Usage

Configure Broadway to use the Sequin producer:

```elixir
defmodule MyApp.Pipeline do
  use Broadway

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          OffBroadwaySequin.Producer,
          consumer: "my-consumer-group",
          token: "your-sequin-token"
        }
      ],
      processors: [
        default: [concurrency: 10]
      ]
    )
  end

  def handle_message(_, message, _) do
    message
  end
end
```

### Producer Options

- `:consumer` - Required. The name of your Sequin consumer group.

- `:token` - Required. Your Sequin API authentication token.

- `:base_url` - Optional. The base URL for the Sequin API.
  Defaults to "https://api.sequinstream.com/api".

## Example

See our [example project](https://github.com/sequinstream/sequin/tree/main/examples/elixir_broadway) for an end-to-end example of how to use this library.

## Learn More

- [Broadway Documentation](https://hexdocs.pm/broadway/introduction.html)
- [Sequin Documentation](https://docs.sequin.io)
- [Off Broadway Producers](https://hexdocs.pm/broadway/introduction.html#non-official-off-broadway-producers)

## License

MIT
