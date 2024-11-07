defmodule OffBroadwaySequin.SequinClient do
  @moduledoc false

  defmodule Config do
    defstruct [
      :consumer,
      :base_url,
      :token,
      :wait_for
    ]
  end

  defmodule MessageData do
    defstruct [
      :ack_id,
      :data,
      :subject
    ]
  end

  def init(config) do
    {:ok,
     %Config{
       consumer: config[:consumer],
       base_url: config[:base_url] || "https://api.sequinstream.com/api",
       token: config[:token],
       wait_for: config[:wait_for] || 120_000
     }}
  end

  def receive(demand, config) do
    url = "/api/http_pull_consumers/#{config.consumer}/receive"

    body = %{
      max_batch_size: demand,
      wait_for: config.wait_for
    }

    case Req.post(base_req(config), url: url, json: body) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        messages =
          Enum.map(body["data"], fn item ->
            %MessageData{
              ack_id: item["ack_id"],
              data: item["data"]["record"]
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
    url = "/api/http_pull_consumers/#{config.consumer}/ack"
    body = %{ack_ids: ack_ids}

    case Req.post(base_req(config), url: url, json: body) do
      {:ok, %Req.Response{status: 200}} ->
        :ok

      {:ok, %Req.Response{} = resp} ->
        {:error, resp}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp base_req(config) do
    Req.new(
      base_url: config.base_url,
      headers: [{"authorization", "Bearer #{config.token}"}],
      max_retries: 3,
      receive_timeout: Enum.max([round(config.wait_for * 1.1), 15_000])
    )
  end
end
