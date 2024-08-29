defmodule Runnable do
  @callback handle_call(:get_name, GenServer.from(), state) :: {:reply, any(), state} when state: any()
  @callback handle_cast(:run, GenServer.from(), state) :: {:reply, any(), state} when state: any()
end
