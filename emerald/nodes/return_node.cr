class ReturnNode < Node
  def initialize(@line : Int32, @position : Int32)
    @value = nil
    @children = [] of Node
  end

  def resolve_value(state : ProgramState) : Nil
    @resolved_value = @children[0].resolved_value
    test = @resolved_value
    state.builder.position_at_end state.active_block
    if test.is_a?(LLVM::Value)
      state.builder.ret test
    elsif test.is_a?(Bool)
      if test == true
        state.builder.ret LLVM.int(LLVM::Int1, 1)
      else
        state.builder.ret LLVM.int(LLVM::Int1, 0)
      end
    elsif test.is_a?(String)
      str_pointer = state.define_or_find_global test
      state.builder.ret str_pointer
    elsif test.is_a?(Int32)
      state.builder.ret LLVM.int(LLVM::Int32, test)
    elsif test.is_a?(Float64)
      state.builder.ret LLVM.double(test)
    elsif test.nil?
      state.builder.ret
    end
  end
end
