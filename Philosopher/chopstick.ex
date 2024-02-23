
defmodule Chopstick do
  def start do
    spawn_link(fn -> available() end)
  end

  def available() do
    receive do
    {:request, from} ->
      :granted
      send(from, :granted)
      gone()
    :quit -> :ok
    end
  end

  def gone() do
    receive do
    :return -> available()
    :quit -> :ok
    end
  end

  def quit(stick) do
    send(stick, :quit)
  end

  ###### First and last solution (naive & non-circular) #####
  def request(stick) do
    send(stick, {:request, self()})
    receive do
      :granted -> :ok
    end
  end

  ##### starvation & timeout solution #####
  # def request(stick, waitTime) do
  #   send(stick, {:request, self()})
  #   receive do
  #     :granted -> :ok
  #   after waitTime ->
  #     :no
  #   end
  # end
 ##### Asynchronous #####
  # def asyncRequest(leftStick, rightStick, waitTime) do
  #   send(leftStick, {:request, self()})
  #   send(rightStick, {:request, self()})
  #   receive do
  #     :granted -> :ok
  #   after waitTime ->
  #     :no
  #   end
  # end

  def return(stick) do
    send(stick, :return)
  end

end
