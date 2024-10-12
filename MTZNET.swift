import Foundation
import Web3
import Dispatch

let infuraMainnetURL = "https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID" // Insira seu Infura Project ID

// Função para verificar o número do bloco atual para uma dada instância Web3
func checkBlockNumber(coreID: Int, rpcURL: String) {
    // Cria uma instância Web3
    guard let url = URL(string: rpcURL) else {
        print("URL inválida para o Core \(coreID).")
        return
    }
    
    let web3 = try! Web3(rpcURL: url.absoluteString)
    
    // Busca o número do bloco atual
    web3.eth.getBlockNumber { (result) in
        switch result {
        case .success(let blockNumber):
            print("Core \(coreID) - Número do bloco atual: \(blockNumber)")
        case .failure(let error):
            print("Core \(coreID) - Erro ao buscar o número do bloco: \(error.localizedDescription)")
        }
    }
}

// Função para iniciar todos os núcleos (3 núcleos HoloSea para Mainnet)
func startHoloSeaCores() {
    let dispatchGroup = DispatchGroup()
    
    let rpcURLs = [
        infuraMainnetURL, // Core 1
        infuraMainnetURL, // Core 2
        infuraMainnetURL  // Core 3
    ]
    
    for (index, rpcURL) in rpcURLs.enumerated() {
        dispatchGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            checkBlockNumber(coreID: index + 1, rpcURL: rpcURL)
            dispatchGroup.leave()
        }
    }
    
    dispatchGroup.notify(queue: .main) {
        print("Todos os núcleos terminaram de verificar os números dos blocos.")
    }
}

// Inicia os núcleos HoloSea para Mainnet
startHoloSeaCores()

// Mantém o programa em execução para aguardar as respostas assíncronas
RunLoop.main.run()
