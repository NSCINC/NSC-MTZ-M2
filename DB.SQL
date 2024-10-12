CREATE TABLE planilhas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dados JSONB NOT NULL
);
INSERT INTO planilhas (nome, dados) VALUES
('Vendas Q1', '{"vendas": [{"produto": "Produto A", "quantidade": 100, "preco": 10.0}, {"produto": "Produto B", "quantidade": 200, "preco": 15.0}]}'),
('Despesas Q1', '{"despesas": [{"categoria": "Marketing", "valor": 500}, {"categoria": "Operacional", "valor": 700}]}');
SELECT * FROM planilhas
ORDER BY data_criacao DESC;  -- Ordena do mais recente para o mais antigo
SELECT * FROM planilhas
WHERE nome = 'Vendas Q1';
SELECT dados->'vendas'->0->>'quantidade' AS quantidade_produto_a
FROM planilhas
WHERE nome = 'Vendas Q1';
SELECT * FROM planilhas
ORDER BY nome ASC;  -- Ordena por nome, do A ao Z
