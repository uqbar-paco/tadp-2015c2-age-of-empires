module Atacante

  attr_accessor :potencial_ofensivo

  def atacar(un_defensor)
    if self.potencial_ofensivo > un_defensor.potencial_defensivo
      danio = self.potencial_ofensivo - un_defensor.potencial_defensivo
      un_defensor.sufri_danio(danio)
    end
    @multiplicador = 1
  end

  def descansar
    @multiplicador = 2
  end

  def potencial_ofensivo
    @potencial_ofensivo * self.multiplicador
  end

  def multiplicador
    @multiplicador || 1
  end
end

module Defensor

  attr_accessor :potencial_defensivo, :energia

  def sufri_danio(danio)
    self.energia= self.energia - danio
  end

  def descansar
    self.energia += 10
  end

  def esta_descansado?
    40 < self.energia
  end

end

class Guerrero < Object
  include Atacante
  alias_method :descansar_atacante, :descansar
  include Defensor
  alias_method :descansar_defensor, :descansar

  attr_accessor :peloton

  def initialize(potencial_ofensivo=20, energia=100, potencial_defensivo=10)
    self.potencial_ofensivo = potencial_ofensivo
    self.energia = energia
    self.potencial_defensivo = potencial_defensivo
  end

  def descansar
    self.descansar_atacante
    self.descansar_defensor
  end

  def sufri_danio(danio)
    super(danio)
    if (!peloton.nil?)
      self.peloton.lastimado
    end
  end

end

class Kamikaze
  include Defensor
  include Atacante

  def initialize
    @potencial_ofensivo = 250
    @energia = 100
    @potencial_defensivo = 10
  end

  def atacar(defensor)
    super(defensor)
    @energia = 0
  end
end


class Espadachin < Guerrero

  attr_accessor :espada

  #constructor
  def initialize(espada)
    super(20, 100, 2)
    self.espada= espada
  end

  def potencial_ofensivo
    super() + self.espada.potencial_ofensivo
  end
end

class Espada
  attr_accessor :potencial_ofensivo

  def initialize(potencial_ofensivo)
    self.potencial_ofensivo= potencial_ofensivo
  end
end

class Misil
  include Atacante

  def initialize(potencial_ofensivo=200)
    self.potencial_ofensivo = potencial_ofensivo
  end

  def sufri_danio(energia)
    raise 'Yo no deberia recibir esto'
  end
end

class Muralla
  include Defensor

  def initialize(potencial_defensivo= 50, energia = 200)
    self.potencial_defensivo = potencial_defensivo
    self.energia = energia
  end

end

class Peloton
  attr_accessor :guerreros, :estrategia, :retirado

  def self.cobarde integrantes
    self.new(integrantes,
      proc {|peloton| peloton.retirate})
  end

  def initialize(integrantes, estrategia)
    self.guerreros =integrantes
    integrantes.each { |i| i.peloton = self }
    self.estrategia = estrategia
    self.retirado = false
  end

  def descansar
    cansados = self.guerreros.select {|integrante|
      ! integrante.esta_descansado?
    }
    cansados.each do |integrante|
      integrante.descansar
    end
  end

  def lastimado
    estrategia.call(self)
  end

  def retirate
    @retirado = true
  end
end

class Descansador
  def call(peloton)
    peloton.descansar
  end
end

class Cobarde
  def call(peloton)
    peloton.retirate
  end
end

class Masoquista
  def call(peloton)
    peloton.retirado = false
  end
end