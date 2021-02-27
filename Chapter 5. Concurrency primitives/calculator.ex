defmodule Calculator do
  def start do
    spawn(fn -> loop(0) end)
  end

  def add(pid, value), do: send(pid, {:add, value})
  def sub(pid, value), do: send(pid, {:sub, value})
  def mul(pid, value), do: send(pid, {:mul, value})
  def div(pid, value), do: send(pid, {:mul, value})

  def value(pid) do
    send(pid, {:value, self()})
    receive do
      {:response, value} -> value
    end
  end

  defp loop(current_value) do
    new_value = receive do
      message -> process_message(current_value, message)
    end

    loop(new_value)
  end

  defp process_message(current_value, {:value, caller}) do
    send(caller, {:response, current_value})
    current_value
  end

  defp process_message(current_value, {:add, value}) do
    current_value + value
  end
  defp process_message(current_value, {:sub, value}) do
    current_value - value
  end
  defp process_message(current_value, {:mul, value}) do
    current_value * value
  end
  defp process_message(current_value, {:div, value}) do
    current_value / value
  end

  defp process_message(current_value, invalid_request) do
    IO.puts("invalid request #{inspect invalid_request}")
    current_value
  end
end
