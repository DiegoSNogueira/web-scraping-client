require 'rubygems'
require 'mechanize'

agent = Mechanize.new

# Cria um novo arquivo
out_file = File.new('dados_imoveis.txt', 'w')
out_file.puts 'PREÇO|QUARTOS|TAMANHO|CONDOMÍNIO|ESTACIONAMENTO|BAIRRO'

page = agent.get("https://ro.olx.com.br/rondonia/porto-velho/imoveis/venda")
num_pages =  page.search('a.sc-1bofr6e-0.iRQkdN')[1]['href'][-2..-1].to_i

def montar_linha detalhes
    array = detalhes.split "|"
    array.insert(0, " ") unless detalhes.include? "quarto"
    array.insert(1, " ") unless detalhes.include? "m²"
    array.insert(2, " ") unless detalhes.include? "Condomínio:"
    array.insert(3, " ") unless detalhes.include? "vaga"
    detalhes = array.join("|")

    detalhes
end

(1..num_pages).each do |i|
    puts i
    page = agent.get("https://ro.olx.com.br/rondonia/porto-velho/imoveis/venda?o=#{i}")
    page.search('div.fnmrjs-2.jiSLYe').each do |p|
        valor = p.search('span.sc-ifAKCX.eoKYee').text
        detalhes = p.search('span.sc-1j5op1p-0').text 
        detalhes = montar_linha detalhes
        local = p.search('span.sc-7l84qu-1').text.gsub("Porto Velho, ", "")
        linha = "#{valor}|#{detalhes.gsub(" Condomínio: ", "")}|#{local}"
        out_file.puts linha if linha.include? "R$"
    end    
end

out_file.close

# quartos - quarto
# dimensao - m2
# condominio - Condomínio:
# vagas estacionamento - vaga

  
  


