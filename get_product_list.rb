require 'rubygems'
require 'mechanize'

agent = Mechanize.new
page = agent.get('https://www.pciconcursos.com.br/vagas/')

# Cria um novo arquivo para guardar a lista de produtos
out_file = File.new('product_list.txt', 'w')
out_file.puts 'Lista Cargos:'

lista_cargos = []

page.search('ul.linkb li').each do |p|
  f = p.search('a')
  item = {:cargo => f[0].text, :link => f[0]['href']}
  lista_cargos << item
end


lista_concursos = []

lista_cargos.each do |i|
  page_cargo = page.link_with(:href => i[:link]).click
  out_file.puts 'Cargo:' + i[:cargo]
  page_cargo.search('div.lista_concursos div.na').each do |p|
    concurso = p.search('div.ca a').first

    orgao = concurso.text 
    link = concurso['href']
    estado = p.search('div.ca div.cc').text
    
    # trabalhando a data com html
    data = p.search('div.ca div.ce').to_html

    # trabalhando a data com string
    # data = p.search('div.ca div.ce').text
    # data.gsub! ' a', ' a '
    # data.gsub! 'a té', 'até '

        
    detalhe = p.search('div.ca div.cd').to_html

    item = {:cargo => i[:cargo], :orgao => orgao,:link => link, :estado => estado, :data => data, :detalhe => detalhe}
    lista_concursos << item
    out_file.puts  item
  end
end


out_file.close