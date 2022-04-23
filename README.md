# README

A Aplicação é um teste técnico onde deveria ser criado uma API para gerenciar agendamentos de salas de reuniões.

Optei por contruir a aplicação com duas tabelas, uma para as Salas (`Rooms`) e outra para as reservas (`Bookings`), escolhi criar uma tabela para as salas mesmo o teste sugirindo que seriam quatro salas, porque assim existe a possibilidade de um upgrade com funcionalidades de gerenciar e cadastrar novas salas de forma mais fácil, e também para ter um relacionamento melhor entre os objetos no banco de dados. Utilizei variáveis de ambiente para algumas informações de restrição de agendamento como informado no enunciado que deveria ser possível apenas usar as salas em horário comercial. Escrevi os testes automatizados utilizando o `Rspec` e para ajudar na padronização do código foi utilizado a `gem Rubocop`. Utilizei como banco de dados o `Postgres`, subindo tanto banco como a aplicação com o Docker Composo e fiz a autenticação utilizando o `devise token auth`

### Informações do Sitema

* Ruby 2.7.2

* Rails 6.1.5

* System dependencies: Docker compose

### Configurações

* É necessário ter instaldo o `Docker Compose` em sua maquina para subir a aplicação, caso não tenha, siga a documentação oficial nos links abaixo
  * Docker: https://docs.docker.com/engine/install/ 
  * Docker-compose: https://docs.docker.com/compose/install/

* Depois de instalado basta apenas rodar o comando `docker-compose up` na pasta do projeto e será feito o build e execução das imagens da aplicação. A API subirá localmente em `http://localhost:3000` e já executará o `rails db:seed` que criará as quatro salas (`Rooms`) iniciais citadas na introdução e também um usuário que pode ser usado nas requisições dos end-point (email: 'test@test.com', password: '123456').

### Usabilidade

* Na pasta `doc/postman` esta salvo uma collection do `Postman` para testar os end-points da aplicação, incluindo variáveis com as informações dos headers para autenticação. OBS: como padrão é necessário realizar uma primeira requisição ao end-point de autenticação com o email e senha do usuário para pegar o `token`, `client`, `uid` e `expiry` que serão passado nos headers para autenticação.

* Os end-points são:
	* POST `/api/auth` -> cria um novo User, é necessário enviar os parâmetros: `email` e `password`.
	* POST `/api/auth/sign_in` -> retorna o token e demais dados de autenticação, deve enviar o `email` e `password` de um usuário existente. 
	* GET `/api/v1/rooms` -> retorna todas as Salas criadas, para poder usar o `id` das mesmas na criação de reservas.
	* GET `/api/v1/bookings` -> retorna as reservas criadas, poder se usar passando os parâmetros `room_id` para retornas as reservas de uma sala específica e também o parâmetro `booking_day`, para retornar as reservas de um data específica, sendo possível combinar os dois.
	* POST `/api/v1/bookings` -> cria uma nova reserva. É necessário enviar os parâmetros: `room_id`, `owner`, `booking_day`, `schedule_starting` e `schedule_ending`, mais abaixo está o tipo de cada parâmetro que deve ser enviado.
	* PUT `/api/v1/bookings/:id_da_reserva` -> atualiza informações de uma reserva já existente. São necessários os mesmos parâmetros usados na criação, além do `id` da reserva que é passado na URL.
	* DELETE `/api/v1/bookings/:id_da_reserva` -> deleta uma reserva existente. É necessário passar o `id` da reserva na URL.

	* Exemplo dos tipos de parâmetros:
		```
		{
			"room_id": 1, // Numero inteiro
			"owner": "Marcos Antonio" // Texto
			"booking_day": "04/04/2022" // Texto, mas deve respeitar esse formato
			"schedule_starting": 900 // Numero inteiro, o horário deve ser passado dessa forma, ex: 10:30 fica 1030
			"schedule_ending": 1100 // Numero inteiro, igual ao schedule_starting
		}
		```

### Como rodar os testes

* Para rodar os testes da aplicação basta usar o comando `docker exec -it desafio_ninja_app rspec` 

