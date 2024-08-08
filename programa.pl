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

