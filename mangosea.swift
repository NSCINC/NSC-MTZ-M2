import Foundation

// Capacidade inicial
let initialCapacity = 10

// Estrutura para o plano de investimento
struct InvestmentPlan {
    var planName: String
    var initialInvestment: Int
    var monthlyReturn: Int
    var annualReturn: Int
    var netAnnualReturn: Int
    var slots: Int
}

// Gerenciador de planos de investimento
class InvestmentPlanManager {
    private var plans: [InvestmentPlan]
    private var count: Int
    private var capacity: Int

    init() {
        self.count = 0
        self.capacity = initialCapacity
        self.plans = []
    }

    // Função para adicionar um plano de investimento
    func addInvestmentPlan(planName: String, initialInvestment: Int, monthlyReturn: Int, annualReturn: Int, netAnnualReturn: Int, slots: Int) {
        // Verifica se é necessário aumentar a capacidade
        if count >= capacity {
            capacity *= 2 // Dobra a capacidade
            plans.reserveCapacity(capacity) // Reserva a nova capacidade sem precisar preencher novos valores
        }

        // Adiciona o novo plano
        let newPlan = InvestmentPlan(planName: planName, initialInvestment: initialInvestment, monthlyReturn: monthlyReturn, annualReturn: annualReturn, netAnnualReturn: netAnnualReturn, slots: slots)
        plans.append(newPlan) // Usa append para adicionar o novo plano
        count += 1 // Incrementa a contagem de planos
    }

    // Função para exibir os planos de investimento
    func displayInvestmentPlans() {
        for plan in plans {
            print("Plano: \(plan.planName)")
            print("Investimento Inicial: \(plan.initialInvestment)")
            print("Retorno Mensal: \(plan.monthlyReturn)")
            print("Retorno Anual: \(plan.annualReturn)")
            print("Retorno Anual Líquido: \(plan.netAnnualReturn)")
            print("Slots: \(plan.slots)")
            print("--------------") // Separador para melhor legibilidade
        }
    }
}

// Função principal
func main() {
    let manager = InvestmentPlanManager()

    // Adicionando alguns planos de investimento como exemplo
    manager.addInvestmentPlan(planName: "Plano A", initialInvestment: 1000, monthlyReturn: 100, annualReturn: 1200, netAnnualReturn: 1000, slots: 5)
    manager.addInvestmentPlan(planName: "Plano B", initialInvestment: 2000, monthlyReturn: 200, annualReturn: 2400, netAnnualReturn: 2000, slots: 10)

    // Exibir os planos de investimento
    manager.displayInvestmentPlans()
}

// Chamada da função principal
main()
