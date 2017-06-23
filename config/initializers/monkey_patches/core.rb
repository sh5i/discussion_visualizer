class Gviz

  def save(path, type=nil)
    #pathにはissueIDが入ってくる
    dot_path = Rails.root.join('tmp', "#{path}.dot")
    svg_path = Rails.root.join('tmp', "#{path}.#{type}")
    File.open(dot_path, "w") { |f| f.puts self }
    system "dot", "-T", type.to_s, dot_path.to_s, "-o", svg_path.to_s if type
  end

end
