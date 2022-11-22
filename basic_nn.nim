import math
import random
import neo
proc sigm(x:float):float=
    1/(1+exp(-x))
proc dersigm(x:float):float=
    sigm(x)*(1-sigm(x))
proc play()=
    let config = @[2,3,1]
    let inputs = @[
        @[1.0,1.0],
        @[1.0,0.0],
        @[0.0,1.0],
        @[0.0,0.0],
    ]
    let outputs = @[
        @[1.0],
        @[1.0],
        @[1.0],
        @[0.0],
    ]
    let max_error=0.5
    let epochs=2000
    let alfa=0.9
    var error=100.0
    var peso_1=makeMatrix(3,2,proc (i,j:int): float = rand(1.0))
    var der_peso_1=makeMatrix(3,2,proc (i,j:int): float = 0.0)
    var bias_1=makeMatrix(3,1,proc(i,j:int):float=rand(1.0))
    var salida_1=makeMatrix(3,1,proc(i,j:int):float=0.0)
    var derivada_1=makeMatrix(3,1,proc(i,j:int):float=0.0)
    var delta_1=makeMatrix(3,1,proc(i,j:int):float=0.0)
    var peso_2=makeMatrix(1,3,proc(i,j:int):float=rand(1.0))
    var der_peso_2=makeMatrix(1,3,proc(i,j:int):float=0.0)
    var bias_2=makeMatrix(1,1,proc(i,j:int):float=rand(1.0))
    var salida_2=makeMatrix(1,1,proc(i,j:int):float=0.0)
    var derivada_2=makeMatrix(1,1,proc(i,j:int):float=0.0)
    var delta_2=makeMatrix(1,1,proc(i,j:int):float=0.0)


    for epoch in countup(1,epochs,1):
        error=0.0
        for inp_i in countup(0,inputs.len-1,1):
            let inp_v=makeMatrix(2,1,proc(i,j:int):float=inputs[inp_i][i])
            let out_v=makeMatrix(1,1,proc(i,j:int):float=outputs[inp_i][i])
            salida_1=peso_1*inp_v+bias_1
            derivada_1=salida_1.map(proc(x:float):float=dersigm(x))
            salida_1=salida_1.map(proc(x:float):float=sigm(x))
            
            salida_2=peso_2*salida_1+bias_2
            derivada_2=salida_2.map(proc(x:float):float=dersigm(x))
            salida_2=salida_2.map(proc(x:float):float=sigm(x))
            let error_v=salida_2-out_v
            delta_2=error_v * derivada_2
            delta_1=derivada_1 |*| peso_2.t * delta_2
            der_peso_1 = alfa * delta_1 * inp_v.t
            der_peso_2 = alfa * delta_2 * salida_1.t
            peso_1 = peso_1 - der_peso_1
            peso_2 = peso_2 - der_peso_2
            bias_1 = bias_1 - alfa * delta_1
            bias_2 = bias_2 - alfa * delta_2
            error += error_v.l_2()
        if(error<=max_error):
            break
    echo error
    for inp_i in countup(0,inputs.len-1,1):
        let out_v=makeMatrix(1,1,proc(i,j:int):float=outputs[inp_i][i])
        let inp_v=makeMatrix(2,1,proc(i,j:int):float=inputs[inp_i][i])
        echo "Inp: ",inp_v
        echo ""
        echo "Out esperada: ",out_v
        salida_1=peso_1*inp_v+bias_1
        salida_1=salida_1.map(proc(x:float):float=sigm(x))
        salida_2=peso_2*salida_1+bias_2
        salida_2=salida_2.map(proc(x:float):float=sigm(x))   
        echo ""
        echo "Out real: ",salida_2
        echo ""
proc play2()=
    let config = @[4,5,2]
    let inputs = @[
        @[1.0,1.0,1,0],
        @[1.0,0.0,0,0],
        @[0.0,1.0,1,1],
        @[0.0,0.0,1,0],
    ]
    let outputs = @[
        @[0.0,0.0],
        @[1.0,1],
        @[1.0,0],
        @[0.0,1],
    ]
    let max_error=0.5
    let epochs=2000
    let alfa=0.9
    var error=100.0
    var peso_1=makeMatrix(5,4,proc (i,j:int): float = rand(1.0))
    var der_peso_1=makeMatrix(5,4,proc (i,j:int): float = 0.0)
    var bias_1=makeMatrix(5,1,proc(i,j:int):float=rand(1.0))
    var salida_1=makeMatrix(5,1,proc(i,j:int):float=0.0)
    var derivada_1=makeMatrix(5,1,proc(i,j:int):float=0.0)
    var delta_1=makeMatrix(5,1,proc(i,j:int):float=0.0)
    var peso_2=makeMatrix(2,5,proc(i,j:int):float=rand(1.0))
    var der_peso_2=makeMatrix(2,5,proc(i,j:int):float=0.0)
    var bias_2=makeMatrix(2,1,proc(i,j:int):float=rand(1.0))
    var salida_2=makeMatrix(2,1,proc(i,j:int):float=0.0)
    var derivada_2=makeMatrix(2,1,proc(i,j:int):float=0.0)
    var delta_2=makeMatrix(2,1,proc(i,j:int):float=0.0)


    for epoch in countup(1,epochs,1):
        error=0.0
        for inp_i in countup(0,inputs.len-1,1):
            let inp_v=makeMatrix(4,1,proc(i,j:int):float=inputs[inp_i][i])
            let out_v=makeMatrix(2,1,proc(i,j:int):float=outputs[inp_i][i])
            salida_1=peso_1*inp_v+bias_1
            derivada_1=salida_1.map(proc(x:float):float=dersigm(x))
            salida_1=salida_1.map(proc(x:float):float=sigm(x))
            
            salida_2=peso_2*salida_1+bias_2
            derivada_2=salida_2.map(proc(x:float):float=dersigm(x))
            salida_2=salida_2.map(proc(x:float):float=sigm(x))
            let error_v=salida_2-out_v
            delta_2=error_v |*| derivada_2
            delta_1=derivada_1 |*| peso_2.t * delta_2
            der_peso_1 = alfa * delta_1 * inp_v.t
            der_peso_2 = alfa * delta_2 * salida_1.t
            peso_1 = peso_1 - der_peso_1
            peso_2 = peso_2 - der_peso_2
            bias_1 = bias_1 - alfa * delta_1
            bias_2 = bias_2 - alfa * delta_2
            error += error_v.l_2()
        if(error<=max_error):
            break
    echo error
    for inp_i in countup(0,inputs.len-1,1):
        let out_v=makeMatrix(2,1,proc(i,j:int):float=outputs[inp_i][i])
        let inp_v=makeMatrix(4,1,proc(i,j:int):float=inputs[inp_i][i])
        echo "Inp: "
        echo inp_v
        echo ""
        echo "Out esperada: "
        echo out_v
        salida_1=peso_1*inp_v+bias_1
        salida_1=salida_1.map(proc(x:float):float=sigm(x))
        salida_2=peso_2*salida_1+bias_2
        salida_2=salida_2.map(proc(x:float):float=sigm(x))   
        echo ""
        echo "Out real: "
        echo salida_2
        echo ""
play2()