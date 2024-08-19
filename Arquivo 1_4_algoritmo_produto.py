import csv

# Definindo a estrutura para armazenar os produtos
produtos = []

# Função para adicionar um produto à lista
def adicionar_produto(descricao, valor, tipo_embalagem):
    produtos.append({
        "descricao": descricao,
        "valor": valor,
        "tipo_embalagem": tipo_embalagem
    })

# Função para coletar dados do usuário
def coletar_dados():
    while True:
        descricao = input("Digite a descrição do produto: ")
        valor = input("Digite o valor do produto: ")
        tipo_embalagem = input("Digite o tipo de embalagem do produto: ")
        adicionar_produto(descricao, valor, tipo_embalagem)

        continuar = input("Deseja cadastrar um novo produto? (sim/não): ")
        if continuar.lower() != 'sim':
            break

# Função para salvar os dados em um arquivo CSV
def salvar_em_csv():
    keys = produtos[0].keys()
    with open('1_5_arquivo_produto.csv', 'w', newline='') as arquivo_csv:
        dict_writer = csv.DictWriter(arquivo_csv, keys)
        dict_writer.writeheader()
        dict_writer.writerows(produtos)

# Executando as funções
coletar_dados()
if len(produtos) >= 5:
    salvar_em_csv()
    print("Arquivo CSV criado com sucesso.")
else:
    print("Cadastro cancelado. É necessário inserir no mínimo 5 produtos.")

