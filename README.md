Documentação de Estudo – Validação Facial Assertiva
Introdução
Este protótipo foi desenvolvido para testar o reconhecimento facial em um app. Durante o desenvolvimento, foram utilizadas soluções open source, como a biblioteca OpenCV (através do pacote opencv_dart) e o arquivo de modelo haarcascade_frontalface_default.xml, para implementar um fluxo de cadastro e autenticação facial.

O objetivo deste estudo é avaliar a assertividade desses métodos open source para validar se uma pessoa realmente é aquela que afirma ser. Foram realizadas pesquisas em fontes diversas (Stack Overflow, Reddit, blogs técnicos, etc.) e também avaliada a possibilidade de desenvolver uma API própria em Python usando OpenCV.

Desafios e Limitações Encontradas
Detecção Básica vs. Validação Assertiva:
As soluções open source, como o uso do OpenCV com o modelo Haar Cascade, conseguem realizar uma detecção básica de rostos, mas não fornecem uma validação assertiva que garanta a identidade exata da pessoa.
Mesmo com ajustes e treinamento, a variabilidade das condições de iluminação, ângulos e expressões faciais pode comprometer a precisão.
Armazenamento Offline vs. Nuvem:
Inicialmente, o protótipo salvava as imagens localmente (em dispositivos individuais). Isso permite que cada condutor (usuário) use o app em seu próprio dispositivo.
Problema: Se o usuário tentar acessar de outro dispositivo, o fluxo de cadastro é acionado novamente, pois a validação é feita com base nas imagens salvas localmente.
Solução Avaliada: Migrar o armazenamento das imagens para a nuvem (através de um endpoint customizado ou serviços especializados) para centralizar o cadastro e permitir a validação independente do dispositivo.
Comparação Simples:
No protótipo, a validação facial foi simulada comparando (por exemplo) o tamanho dos arquivos de imagem, o que não garante a similaridade real dos rostos e pode levar a falsos positivos ou negativos.
Análise de Alternativas
Soluções Open Source
OpenCV com opencv_dart:
Vantagens:
Totalmente gratuito e open source.
Flexível para customizações.
Desvantagens:
A detecção funciona bem para identificar a presença de um rosto, mas não para autenticar de forma assertiva a identidade.
Requer um trabalho extenso de ajustes, treinamento e validação para chegar a um nível de confiabilidade comparável às soluções pagas.
Mesmo com uma API própria em Python utilizando OpenCV, a assertividade pode não ser suficiente para um sistema de validação de identidade robusto.
Soluções Pagas
Firebase ML Kit:
Vantagens:
Alta precisão e fácil integração.
Possui um nível gratuito (por exemplo, alguns milhares de transações por mês – consulte a documentação atual para os limites exatos).
Escalabilidade e suporte da Google.
Desvantagens:
Após ultrapassar os limites gratuitos, há custos que podem ser mensais.
Microsoft Face API (Azure Cognitive Services):
Vantagens:
Alta assertividade e reconhecimento de rostos com diversos parâmetros (como verificação de identidade, detecção de emoções, etc.).
Nível gratuito que pode ser suficiente para um protótipo ou baixo volume de requisições (por exemplo, até 30.000 transações por mês – verificar os limites atualizados na documentação da Azure).
Desvantagens:
Após o limite gratuito, os custos podem aumentar de acordo com o volume de requisições.
Dependência de uma conexão estável com a internet e do serviço da Microsoft.
Conclusão
Em resumo, soluções open source podem ser utilizadas para detectar rostos, mas dificilmente oferecerão uma validação facial assertiva (reconhecimento de identidade) de forma gratuita e com alta confiabilidade.
Para um reconhecimento facial realmente assertivo, que garanta que a pessoa é aquela que diz ser, as melhores opções são os serviços pagos (com níveis gratuitos limitados) como o Firebase ML Kit ou a Microsoft Face API.
Essas soluções oferecem precisão e robustez superiores, embora possam gerar custos após o uso do limite gratuito.

Mesmo com um backend próprio usando OpenCV, o nível de assertividade dificilmente alcançará o dos serviços pagos, pois eles contam com algoritmos avançados, treinamento extensivo em grandes volumes de dados e infraestrutura otimizada para esse fim.