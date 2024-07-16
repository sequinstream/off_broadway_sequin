defmodule OffBroadwaySequin.SequinClient do
  @moduledoc false

  defmodule Config do
    defstruct [
      :stream,
      :consumer
    ]
  end

  defmodule Message do
    defstruct [
      :ack_id,
      :data,
      :subject
    ]
  end

  def init(config) do
    {:ok,
     %Config{
       stream: config[:stream],
       consumer: config[:consumer]
     }}
  end

  def receive(demand, config) do
    url = "/api/streams/#{config.stream}/consumers/#{config.consumer}/next"
    query = [batch_size: demand]

    case Req.get(base_req(), url: url, params: query) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        messages =
          Enum.map(body["data"], fn item ->
            %Message{
              ack_id: item["ack_token"],
              data: item["message"]["data"],
              subject: item["message"]["subject"]
            }
          end)

        {:ok, messages}

      {:ok, %Req.Response{} = resp} ->
        {:error, resp}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def ack([], _config), do: :ok

  def ack(ack_ids, config) do
    url = "/api/streams/#{config.stream}/consumers/#{config.consumer}/ack"
    body = %{ack_tokens: ack_ids}

    case Req.post(base_req(), url: url, json: body) do
      {:ok, %Req.Response{status: 204}} ->
        :ok

      {:ok, %Req.Response{} = resp} ->
        {:error, resp}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp base_req do
    Req.new(
      base_url: "http://localhost:7376",
      max_retries: 3
    )
  end
end
