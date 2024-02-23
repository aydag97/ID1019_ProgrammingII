defmodule Dinner do

  def start(n), do: spawn(fn -> init(n) end)

  def init(n) do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    t0 = :erlang.timestamp()
    #### test of naive solution ####
    # Philosopher.start(:arendt, c1, c2, n, ctrl)
    # Philosopher.start(:hypatia, c2, c3, n, ctrl)
    # Philosopher.start(:simone, c3, c4, n, ctrl)
    # Philosopher.start(:elisabeth, c4, c5, n, ctrl)
    # Philosopher.start(:ayn, c5, c1, n, ctrl)

    #### test of strength & asynchronous solution ####
    # Philosopher.start(:arendt, c1, c2, 5, ctrl, 5)
    # Philosopher.start(:hypatia, c2, c3, 5, ctrl, 5)
    # Philosopher.start(:simone, c3, c4, 5, ctrl, 5)
    # Philosopher.start(:elisabeth, c4, c5, 5, ctrl, 5)
    # Philosopher.start(:ayn, c5, c1, 5, ctrl, 5)

    #### test of non-circular solution ####
    Philosopher.start(:arendt, c1, c2, n, ctrl)
    Philosopher.start(:hypatia, c2, c3, n, ctrl)
    Philosopher.start(:simone, c3, c4, n, ctrl)
    Philosopher.start(:elisabeth, c4, c5, n, ctrl)
    Philosopher.start(:ayn, c1, c5, n, ctrl)

    wait(5, [c1, c2, c3, c4, c5], t0)
  end

  def wait(0, chopsticks, t0) do
    t1 = :erlang.timestamp()
    IO.puts("done in #{div(:timer.now_diff(t1,t0), 1000)} ms")
   Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end

  def wait(n, chopsticks, t0) do
    receive do
    :done ->
      wait(n - 1, chopsticks, t0)
    :abort ->
      Process.exit(self(), :kill)
    end
  end

end
