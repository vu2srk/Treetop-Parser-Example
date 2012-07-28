require 'treetop'

# load custom syntax nodes
require File.expand_path(File.join(File.dirname(__FILE__), 'node_extensions.rb'))

class Parser
	# load the instance of parser once as a class variable
	Treetop.load(File.join(File.dirname(__FILE__), 'trial_parser.treetop'))
	@@parser = TrialParser.new

	def self.parse(data)
		tree = @@parser.parse(data)

		#error catching if tree is empty
		if (tree.nil?)
			raise Exception, "Parse error at offset: #{@@parser.index}"
		end
		
		self.clean_tree(tree)

		return tree.to_array
	end

	private   
     	def self.clean_tree(root_node)
     		return if(root_node.elements.nil?)
       		root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
       		root_node.elements.each {|node| self.clean_tree(node) }
     	end
end

print Parser.parse('(this "is" a test(1 2.0 3))')
