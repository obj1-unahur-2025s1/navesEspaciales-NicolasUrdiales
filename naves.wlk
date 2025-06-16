class Nave{
    var velocidad
    var direccion
    var combustible
    method acelerar(cuanto){velocidad = (velocidad + cuanto).min(100000)}
    method desacelerar(cuanto) {velocidad = (velocidad - cuanto).max(0)}
    method irHaciaElSol(){direccion = 10}
    method escaparDelSol(){direccion = -10}
    method ponerseParaleloAlSol(){direccion = 0}
    method acercarseUnPocoAlSol(){direccion = (direccion + 1).min(10)}
    method alejarseUnPocoDelSol(){direccion = (direccion - 1).max(0)}
    method initialize(){
        if(direccion > 10 and direccion < -10){
            self.error("La direccion es invalida")
        }
    }
    method prepararViaje()
    method cargarCombustible(cantidad){combustible += cantidad}
    method descargarCombustible(cantidad) {combustible = (combustible - cantidad).max(0)}
    method estaTranquila() = combustible >= 4000 and velocidad < 12000
    method escapar()
    method avisar()
    method recibirAmenaza() {
        self.escapar()
        self.avisar()
    }
    method estaDeRelajo() = self.estaTranquila() and self.tienePocaActividad()
    method tienePocaActividad()
}

class NaveBaliza inherits Nave{
    var baliza
    var cambioDeBaliza = false
    method cambiarColorDeBaliza(colorNuevo) {
        baliza = colorNuevo
        cambioDeBaliza = true
    }
    method baliza() = baliza
    override method prepararViaje(){
        self.cambiarColorDeBaliza("verde")
        self.ponerseParaleloAlSol()
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }
    override method estaTranquila() = super() and baliza != "rojo"
    override method escapar(){self.irHaciaElSol()}
    override method avisar(){self.cambiarColorDeBaliza("rojo")}
    override method tienePocaActividad() = !cambioDeBaliza
}


class NavePasajeros inherits Nave{
    var pasajeros
    var cantidadComida
    var cantidadBebida
    var comidaServida = 0
    method cargarComida(cantidad){cantidadComida += cantidad}
    method descargarComida(cantidad){cantidadComida = (cantidadComida - cantidad).max(0)}
    method cargarBebida(cantidad){cantidadBebida += cantidad}
    method descargarBebida(cantidad){cantidadBebida = (cantidadBebida - cantidad).max(0)}
    override method prepararViaje(){
        self.cargarComida(4)
        self.cargarBebida(6)
        self.acercarseUnPocoAlSol()
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }
    method pasajeros() = pasajeros
    override method escapar(){self.acelerar(velocidad)}
    override method avisar(){self.darDeComerYBeberALosPasajeros()}
    method darDeComerYBeberALosPasajeros(){
        cantidadComida = (cantidadComida - 1).max(0)
        comidaServida += 1
        cantidadBebida = (cantidadBebida - 1).max(0)
    }
    override method tienePocaActividad() = comidaServida < 50
}


class NaveCombate inherits Nave{
    var invisible
    var misilesDesplegados
    const mensajes = []
    method ponerseVisible(){invisible = false}
    method ponerseInvisible(){invisible = true}
    method estaInvisible() = invisible
    method desplegarMisiles() {misilesDesplegados = true}
    method replegarMisiles() {misilesDesplegados = false}
    method misilesDesplegados() = misilesDesplegados
    method emitirMensaje(mensaje){mensajes.add(mensaje)}
    method mensajesEmitidos() = mensajes.size()
    method primerMensajeEmitido() = mensajes.first()
    method ultimoMensajeEmitido() = mensajes.last()
    method esEscueta() = mensajes.all({m => m.size() < 30})
    override method prepararViaje(){
        self.ponerseVisible()
        self.replegarMisiles()
        self.cargarCombustible(30000)
        self.acelerar(5000)
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en mision")
    }
    override method estaTranquila() = super() and misilesDesplegados == false
    override method escapar(){
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }
    override method avisar(){
        self.emitirMensaje("Amenaza recibida")
    }
    override method tienePocaActividad() = self.mensajesEmitidos() < 8
}

class NaveHospital inherits NavePasajeros{
    var tieneQuirofano
    method tieneQuirofano() = tieneQuirofano
    method initialize(){
        if(!tieneQuirofano == true or !tieneQuirofano == false){
            self.error(tieneQuirofano + "Debe ser un valor booleano")
        }
    }
    override method estaTranquila() = !self.tieneQuirofano()
    override method recibirAmenaza(){
        super()
        tieneQuirofano = true
    }
}

class NaveCombateSigilosa inherits NaveCombate{
    override method estaTranquila() = super() and !self.estaInvisible()
    override method escapar(){
        super()
        self.desplegarMisiles()
        self.ponerseInvisible()
    }
}








