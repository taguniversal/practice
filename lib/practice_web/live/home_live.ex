defmodule PracticeWeb.HomeLive do
  use Phoenix.LiveView
  import Benchee.Conversion.Duration

  require Logger

  def mount(_params, _session, socket) do
    exercises = Registry.select(Registry.Exercises, [{{:"$1", :_, :_}, [], [:"$1"]}])
    Logger.info("HoneLive got exercises: #{inspect exercises}")
    Phoenix.PubSub.subscribe(Practice.PubSub, "benchmark:results:two_sum")
    {:ok, assign(socket, exercises: exercises, two_sum: nil)}
  end

  @spec handle_event(any(), any(), any()) :: none()
  def handle_event("run-exercise", %{"name" => name}, socket) do
    name_atom = String.to_existing_atom(name)
    [{exercise, val}] =  Registry.lookup(Registry.Exercises, name_atom)
    Logger.info("Running exercise: #{name}")
    GenServer.cast(exercise, :run)
    socket = assign(socket, :two_sum, nil)
    {:noreply, socket}
  end

  @impl true
  def handle_info(result, socket) do
    Logger.info("LiveView: Benchmark results received: #{inspect result}")
    {:noreply, assign(socket, two_sum: result)}
  end

  def format_scenario(scenario) do
    inspect scenario
  end

  def format_benchmark(nil) do
    assigns = %{}
    ~H"""
    """
  end

  def format_benchmark(%Benchee.Suite{} = benchmark) do
    assigns = %{scenarios: benchmark.scenarios}
   ~H"""
    <div>
      <h3>Benchmark Results</h3>
      <table>
        <thead>
          <tr>
            <th>Scenario</th>
          </tr>
          </thead>
      <%= for scenario <- @scenarios do %>
      <tr>
      <td>
      <%= format(scenario.run_time_data.statistics.average) %>
      </td>
      </tr>
      <% end %>
      </table>
    </div>
    """
  end

end
