% Parcial Influencers

% Los predicados principales deben ser completamente inversibles

% Los usuarios tienen canales en distintas redes sociales con 
% distinta cantidad de seguidores en cada una

% 1) Modelar los siguientes usuarios de ejemplo

%canal(Persona, TipoDeCanal, CantSeguidores).
canal(ana, youtube, 3000000).
canal(ana, instagram, 2700000).
canal(ana, tiktok, 1000000).
canal(ana, twitch, 2).

canal(beto, twitch, 120000).
canal(beto, youtube, 6000000).
canal(beto, instagram, 1100000).
% NO tiene un canal un tiktok

canal(cami, tiktok, 2000).
% NO tiene otros canales

canal(dani, youtube, 1000000).

canal(evelyn, instagram, 1).

% 2) Sobre los influencer...
% a) influencer/1 se cumple para un usuario que tiene más de 
% 10.000 seguidores en total entre todas sus redes.
% En los usuarios de ejemplo, dani, ana y beto son influencers

influencer(Usuario) :-
    cantidadDeSeguidores(Usuario, SeguidoresTotal),
    SeguidoresTotal > 10000.

cantidadDeSeguidores(Usuario, Total) :-
    usuario(Usuario),
    findall(Seguidores, canal(Usuario, _, Seguidores), ListaDeSeguidores),
    sum_list(ListaDeSeguidores, Total).
    
usuario(Alguien) :- canal(Alguien, _, _).

% b) omnipresente/1 se cumple para un influencer si está en cada red
% que existe (se consideran como existentes aquellas redes en las que
% hay al menos un usuario). Por ejemplo, ana es omnipresente

red(Red) :- canal(_, Red, _).

omnipresente(Usuario) :-
    usuario(Usuario),
    forall(red(Red), canal(Usuario, Red, _)).
    
% c) exclusivo/1 se cumple cuando un influencer está en una única red.
% Por ejemplo, dani es exclusivo.

exclusivo(Usuario) :-
    usuario(Usuario),
    not(estaEnDosRedes(Usuario)).

estaEnDosRedes(Usuario) :-
    canal(Usuario, Red1, _),
    canal(Usuario, Red2, _),
    Red1 \= Red2.

% 3) Tipos de Contenidos
% video(QuienesAparecen, Duracion)
% foto(QuienesAparecen)
% stream(Tematica)

% a) Modelar los contenidos de forma tal que a futuro pueden existir 
% otros tipos de contenido 

publico(ana, tiktok, video([beto, evelyn], 1)).
publico(ana, tiktok, video([ana], 1)).
publico(ana, instagram, foto([ana])).

publico(beto, instagram, foto([])).

publico(cami, twitch, stream(leagueOfLegends)).
publico(cami, youtube, video([cami], 5)).

publico(evelyn, instagram, foto([evelyn, cami])).

% b) Se sabe que las temáticas relacionadas con juegos 
% son leagueOfLegends, minecraft y aoe. Agregar esta 
% información a la base de conocimientos.

juego(leagueOfLegends).
juego(minecraft).
juego(aoe).

% 4) adictiva/1 se cumple para una red cuando sólo tiene contenidos
% adictivos (Un contenido adictivo es un video de menos de 3
% minutos, un stream sobre una temática relacionada con juegos, 
% o una foto con menos de 4 participantes)

adictiva(Red) :-
    red(Red),
    forall(publico(_,Red,Contenido), contenidoAdictivo(Contenido)).
    % para todo contenido publicado en la Red, dicho contenido es adictivo

contenidoAdictivo(video(_,Duracion)) :- Duracion < 3.
contenidoAdictivo(stream(Tema)) :- juego(Tema).
contenidoAdictivo(foto(Participantes)) :-
    length(Participantes, Cantidad),
    Cantidad < 4.

% 5) colaboran/2 se cumple cuando un usuario aparece en las redes 
% de otro (en alguno de sus contenidos). En un stream siempre 
% aparece quien creó el contenido.
% Esta relación debe ser simétrica. (O sea, si a colaboró con b, 
% entonces también debe ser cierto que b colaboró con a)
% Por ejemplo, beto colaboró con ana y ana colaboró con evelyn.

colaboran(P1, P2) :- colaboranJuntos(P1, P2).
colaboran(P1, P2) :- colaboranJuntos(P2, P1).

colaboranJuntos(Usuario, OtroUsuario) :-
    publicoContenidoCon(Usuario, OtroUsuario),
    Usuario \= OtroUsuario.

publicoContenidoCon(Usuario, OtroUsuario) :-
    publico(Usuario, _, Contenido),
    apareceEn(Usuario, Contenido, OtroUsuario).
    
apareceEn(_, video(Participantes, _), OtroUsuario) :-
    member(OtroUsuario, Participantes).

apareceEn(_, foto(Participantes), OtroUsuario) :-
    member(OtroUsuario, Participantes).
    
apareceEn(Usuario, stream(_), Usuario).

% en el caso del strem NO puede aparecer el OtroUsuario!!
% --> En un stream siempre aparece quien creó el contenido.

% 6) caminoALaFama/1 se cumple para un usuario no influencer cuando 
% un influencer publicó contenido en el que aparece el usuario, 
% o bien el influencer publicó contenido donde aparece otro usuario
% que a su vez publicó contenido donde aparece el usuario. 
% Debe valer para cualquier nivel de indirección.
% - Cami está camino a la fama porque evelyn publicó una foto suya 
% (y a su vez ana, que es influencer, publicó un video donde aparece 
% evelyn).
% - Beto no está camino a la fama aunque ana haya publicado un 
% video con él, ¡porque ya es famoso, es influencer!

caminoALaFama(Usuario) :-
    usuario(Usuario),
    not(influencer(Usuario)),
    influencer(Influencer),
    cadenaDepublicoContenidoCon(Influencer, Usuario).

cadenaDepublicoContenidoCon(Influencer, Usuario) :-
    publicoContenidoCon(Influencer, Usuario).

cadenaDepublicoContenidoCon(Influencer, Usuario) :-
    publicoContenidoCon(Influencer, UsuarioIntermedio),
    cadenaDepublicoContenidoCon(UsuarioIntermedio, Usuario).

% 7)
% a) Hacer al menos un test que pruebe que una consulta existencial 
% sobre alguno de los puntos funcione correctamente

% ? - influencer(Persona).
% Persona = ana ;
% Persona = beto ;
% Persona = dani ;

% b) ¿Qué hubo que hacer para modelar que beto no tiene tiktok? 
% Justificar conceptualmente.

/*
Para modelar que beto NO tiene un canal de tiktok simplemente NO habia
que agregarlo a la base de conocimientos, debido al concepto de universo
cerrado que considera verdadero a todo lo que este explicitado en el codigo
mientras tanto, todo lo que no este en el codigo se considera Falso.
Entonces volviendo a caso de beto, si consulto en la terminal:
? - canal(beto, tiktok, _).
false.
Me tira false porque Prolog busco en la base de conocimientos y NO
encontre dicho hecho, por lo tanto lo considera como falso.

NO hubo que agregar ninguna línea de código. 
Quien consulte ?- canal(beto, tiktok, _). obtendrá falso por el 
concepto de universo cerrado: 
todo lo que no esté en la base de conocimientos es falso. 
Entonces, al no agregarlo ya estoy diciendo 
"beto no tiene tiktok" implícitamente.

*/
