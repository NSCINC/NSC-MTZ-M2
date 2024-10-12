import Foundation

// Constantes
let NUM_INPUT = 10         // Número de entradas
let NUM_HIDDEN = 20        // Número de neurônios na camada oculta
let NUM_OUTPUT = 1         // Número de saídas
let MAX_EPOCHS = 1000      // Máximo de épocas de treinamento
let ERROR_THRESHOLD = 0.01  // Limite de erro para treinamento

// Estrutura para a rede neural
struct NeuralNetwork {
    var weightsInputHidden: [[Double]]
    var weightsHiddenOutput: [[Double]]
    var hiddenLayer: [Double]
    var outputLayer: [Double]
    var learningRate: Double

    init() {
        weightsInputHidden = Array(repeating: Array(repeating: 0.0, count: NUM_HIDDEN), count: NUM_INPUT)
        weightsHiddenOutput = Array(repeating: Array(repeating: 0.0, count: NUM_OUTPUT), count: NUM_HIDDEN)
        hiddenLayer = Array(repeating: 0.0, count: NUM_HIDDEN)
        outputLayer = Array(repeating: 0.0, count: NUM_OUTPUT)
        learningRate = 0.01
    }
}

// Função de ativação Sigmoid
func sigmoid(_ x: Double) -> Double {
    return 1 / (1 + exp(-x))
}

// Derivada da função Sigmoid
func sigmoidDerivative(_ x: Double) -> Double {
    return x * (1 - x)
}

// Inicializa a rede neural com pesos aleatórios
func initializeNetwork(_ nn: inout NeuralNetwork) {
    for i in 0..<NUM_INPUT {
        for j in 0..<NUM_HIDDEN {
            nn.weightsInputHidden[i][j] = Double.random(in: -1.0...1.0) // Peso aleatório entre -1 e 1
        }
    }
    for j in 0..<NUM_HIDDEN {
        for k in 0..<NUM_OUTPUT {
            nn.weightsHiddenOutput[j][k] = Double.random(in: -1.0...1.0) // Peso aleatório entre -1 e 1
        }
    }
}

// Função de treinamento da rede neural
func train(nn: inout NeuralNetwork, input: [[Double]], output: [[Double]], numSamples: Int) {
    for epoch in 0..<MAX_EPOCHS {
        var totalError = 0.0
        for s in 0..<numSamples {
            // Feedforward
            for j in 0..<NUM_HIDDEN {
                var activation = 0.0
                for i in 0..<NUM_INPUT {
                    activation += input[s][i] * nn.weightsInputHidden[i][j]
                }
                nn.hiddenLayer[j] = sigmoid(activation)
            }

            for k in 0..<NUM_OUTPUT {
                var activation = 0.0
                for j in 0..<NUM_HIDDEN {
                    activation += nn.hiddenLayer[j] * nn.weightsHiddenOutput[j][k]
                }
                nn.outputLayer[k] = sigmoid(activation)
            }

            // Cálculo do erro
            let error = output[s][0] - nn.outputLayer[0]
            totalError += error * error

            // Backpropagation
            let outputDelta = error * sigmoidDerivative(nn.outputLayer[0])
            for j in 0..<NUM_HIDDEN {
                nn.weightsHiddenOutput[j][0] += nn.learningRate * outputDelta * nn.hiddenLayer[j]
            }

            for j in 0..<NUM_HIDDEN {
                let hiddenDelta = outputDelta * nn.weightsHiddenOutput[j][0] * sigmoidDerivative(nn.hiddenLayer[j])
                for i in 0..<NUM_INPUT {
                    nn.weightsInputHidden[i][j] += nn.learningRate * hiddenDelta * input[s][i]
                }
            }
        }

        totalError /= Double(numSamples)
        if totalError < ERROR_THRESHOLD {
            print("Treinamento interrompido precocemente na época \(epoch)")
            break
        }
    }
}

// Função para prever com a rede neural treinada
func predict(nn: NeuralNetwork, input: [Double]) {
    for j in 0..<NUM_HIDDEN {
        var activation = 0.0
        for i in 0..<NUM_INPUT {
            activation += input[i] * nn.weightsInputHidden[i][j]
        }
        nn.hiddenLayer[j] = sigmoid(activation)
    }

    for k in 0..<NUM_OUTPUT {
        var activation = 0.0
        for j in 0..<NUM_HIDDEN {
            activation += nn.hiddenLayer[j] * nn.weightsHiddenOutput[j][k]
        }
        nn.outputLayer[k] = sigmoid(activation)
    }

    print("Previsão: \(nn.outputLayer[0])")
}

// Função principal
func main() {
    var nn = NeuralNetwork()
    initializeNetwork(&nn)

    // Dados de treinamento fictícios
    let input: [[Double]] = [
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
    let output: [[Double]] = [
        [1],
        [1]
    ]

    // Treinar a rede neural
    train(nn: &nn, input: input, output: output, numSamples: 2)

    // Realizar previsões
    let newInput: [Double] = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    predict(nn: nn, input: newInput)
}

// Chamada da função principal
main()
