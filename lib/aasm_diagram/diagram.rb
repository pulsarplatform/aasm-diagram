module AASMDiagram
  class Diagram
    def initialize(aasm_instance, filename=nil, type=:LR)
      @aasm_instance = aasm_instance
      @type = type
      
      init_graph
      save(filename) if filename
    end

    def init_graph
      @graph = {}
      collect_nodes
      collect_edges
    end

    def collect_nodes
      state_names.map do |state_name|
        @graph[state_name.to_s] = []
      end
    end

    def collect_edges
      events.each do |event|
        event.transitions.each do |transition|
          from = transition.from.to_s
          to = transition.to.to_s
          label = event.name.to_s
          @graph[from] << { edge: to, label: label } unless from.nil?
        end
      end
    end
    
    def raw
      result = []
      result << "flowchart #{@type}"
      
      @graph.each_entry do |from, connections|
        if connections.empty?
          result << from
          next
        end

        connections.each do |connection|
          edge, label = connection.values_at(:edge, :label)

          result << "#{from} -->|#{label}|#{edge}"
        end
      end
      
      result
    end
    
    def to_s
      raw.join(';')
    end

    def save(filename)
      File.open(filename, 'w') do |f|
        raw.each do |line|
          f.puts "#{line};"
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
