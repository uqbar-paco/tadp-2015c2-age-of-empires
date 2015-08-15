require 'rspec'
require_relative '../src/age'

describe 'age of empires tests' do
  #Los guerreros tienen estos parámetros por default: potencial_ofensivo=20, energia=100, potencial_defensivo=10
  it 'vikingo ataca a atila' do
    atila= Guerrero.new
    vikingo = Guerrero.new 70

    vikingo.atacar atila
    expect(atila.energia).to eq(40)
  end

  it 'espadachin ataca a atila' do
    atila= Guerrero.new
    don_quijote = Espadachin.new(Espada.new(50))

    don_quijote.atacar atila
    expect(atila.energia).to eq(40)
  end

  it 'atila ataca a vikingo pero no le hace daño' do
    atila= Guerrero.new
    vikingo = Guerrero.new 70

    atila.atacar vikingo
    expect(atila.energia).to eq(100)
  end

  it 'Muralla solo defiende' do
    muralla = Muralla.new
    vikingo = Guerrero.new 70

    vikingo.atacar(muralla)
    expect(muralla.energia).to eq(180)
    vikingo.atacar(muralla)
    expect(muralla.energia).to eq(160)
  end

  it 'Muralla no ataca' do
    muralla = Muralla.new
    don_quijote = Espadachin.new(Espada.new(40))
    #Esto es la manera sintáctica de decir que lo que se espera dentro de los {} del expect, lanza una exception.
    #Despues veremos que quieren decir los {}
    expect { muralla.atacar don_quijote }.to raise_error(NoMethodError)
  end

end