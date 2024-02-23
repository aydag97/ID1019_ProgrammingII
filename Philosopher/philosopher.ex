defmodule Philosopher do

  @dreaming 100
  @eating 10
  @delay 10
  @timeout 100

  # ctrl is the ID of the mother process
  def start(name, left, right, hunger, ctrl, strength) do
    spawn_link(fn -> dreaming(name, left, right, hunger, ctrl, strength) end)
  end

  def dreaming(name, _left, _right, 0, ctrl, _strength) do
    IO.puts("#{name} is done eating!\n")
    send(ctrl, :done)
  end
  def dreaming(name, left, right, hunger, ctrl, strength) do
    IO.puts("#{name} is dreaming now!\n")
    sleep(@dreaming)
    IO.puts("#{name} has woken up!\n")
    waiting(name, left, right, hunger, ctrl, strength)
  end

  ####### Waiting/5 for the first and last solution (naive & non-circular) #######

  def waiting(name, left, right, hunger, ctrl) do
    IO.puts("#{name} is waiting for chopsticks!\n")
    case Chopstick.request(left) do
      :ok ->
        sleep(@delay)
        case Chopstick.request(right) do
          :ok ->
            eating(name, left, right, hunger, ctrl)
        end
    end
  end

  ####### Waiting/6 for the first deadlock solution (starvation & timeout) #######

  # def waiting(name, left, right, hunger, ctrl, strength) do
  #   IO.puts("#{name} is waiting for left chopstick!\n")
  #   case Chopstick.request(left, @timeout) do
  #     :ok ->
  #       sleep(@delay)
  #       IO.puts("#{name} is waiting for right chopstick!\n")
  #       case Chopstick.request(right, @timeout) do
  #         :ok ->
  #           IO.puts("#{name} has received chopsticks!\n")
  #           eating(name, left, right, hunger, ctrl, strength)
  #         :no ->
  #           Chopstick.return(right)
  #           Chopstick.return(left)
  #           if(strength == 0) do
  #             die(name, left, right, hunger, ctrl, 0)
  #           else
  #             dreaming(name, left, right, hunger, ctrl, strength-1)
  #           end
  #       end
  #     :no ->
  #       Chopstick.return(left)
  #       if(strength == 0) do
  #         die(name, left, right, hunger, ctrl, 0)
  #       else
  #         dreaming(name, left, right, hunger, ctrl, strength-1)
  #       end
  #   end
  # end

 ####### Waiting/6 for the second deadlock solution (asynchronous request) #######

  # def waiting(name, left, right, hunger, ctrl, strength) do
  #   IO.puts("#{name} is waiting for chopsticks!\n")
  #   case Chopstick.asyncRequest(left, right, @timeout) do
  #     :ok ->
  #       sleep(@delay)
  #       eating(name, left, right, hunger, ctrl, strength)
  #     :no ->
  #       if(strength == 0) do
  #         die(name, left, right, hunger, ctrl, 0)
  #       else
  #         dreaming(name, left, right, hunger, ctrl, strength-1)
  #       end
  #   end
  # end

  def eating(name, left, right, hunger, ctrl, strength) do
    IO.puts("#{name} is eating!\n")
    sleep(@eating)
    Chopstick.return(left)
    Chopstick.return(right)
    dreaming(name, left, right, hunger-1, ctrl, strength)
  end

  def die(name, _, _, hunger, ctrl, 0) do
    IO.puts("#{name} died while she was #{hunger} unit(s) hungry!\n")
    send(ctrl, :quit)
  end

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

end
