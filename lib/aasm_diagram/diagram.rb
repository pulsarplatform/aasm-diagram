module AASMDiagram
  class Diagram
    def initialize(aasm_instance, filename, type=:LR)
      @aasm_instance = aasm_instance
      @type = type
      draw
      save(filename)
    end

    def draw
      @graph = {}
      draw_nodes
      draw_edges
    end

    def draw_nodes
      state_names.map do |state_name|
        @graph[state_name.to_s] = []
      end
    end

    def draw_edges
      events.each do |event|
        event.transitions.each do |transition|
          from = transition.from.to_s
          to = transition.to.to_s
          label = event.name.to_s
          @graph[from] << { edge: to, label: label } unless from.nil?
        end
      end
    end

    def save(filename)
      File.open(filename, 'w') do |f|
        f.puts "flowchart #{@type};"
        @graph.each_entry do |from, connections|
          if connections.empty?
            f.puts "    #{from};"
            next
          end

          connections.each do |connection|
            edge, label = connection.values_at(:edge, :label)

            f.puts "    #{from} -->|#{label}|#{edge};"
          end
        end
      end
    end

    private

    def states
      @aasm_instance.states
    end

    def state_names
      states.map(&:name)
    end

    def events
      @aasm_instance.events.first.state_machine.events.values
    end
  end
end
