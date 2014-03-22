rand = Random.new
cmds = ['up', 'right', 'down', 'left']

loop do
  continued = STDIN.gets.to_i
  scores = STDIN.gets.split(' ').map { |w| w.to_i }
  tiles = (1 .. 4).map { |y| STDIN.gets.split(' ').map { |w| w.to_i } }
  if continued == 0
    STDOUT.puts('exit')
    STDOUT.flush()
    break
  end
  STDOUT.puts(cmds[rand.rand(4)])
  STDOUT.flush()
end
