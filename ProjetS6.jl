using DataStructures
using PyPlot


#######################################################################################################################################################

###
#    Fonction toMatrix qui retourne le fichier map sous forme de matrice utilisable par l'algorithme
##

#######################################################################################################################################################


function toMatrix(file)

    open("./"*file) do f

        #readline(f) retourne toute une ligne en chaine de caractere
        if readline(f)!= "type octile" return("Erreur : pas un fichier .map") end

        height = readline(f)
        height = parse(Int64, height[8:end])  #cast le deuxieme parametre au type rentré en premier parametre

        width = readline(f)
        width = parse(Int64, width[7:end])  #chaine[3:5] prend les caractere de 5 a 8 d'une chaine

        readline(f)

        #creer une matrice vide de height x width
        matrix = Matrix{Char}(undef,height,width)
        #@show matrix 

        for i in 1:height 

            line = readline(f)
            
            for j in 1:width

                matrix[i,j] = line[j]              

            end
        
        end


        #@show matrix
        
        return matrix

    end


end


#######################################################################################################################################################

###
#    Fonction cout qui retourne le cout pour aller sur une case
##

#######################################################################################################################################################



function cout(a::Tuple{Int64,Int64}, Matrix::Matrix{Char})

    charA = Matrix[a[1],a[2]]

    if(charA == '.') return 1 end

    if(charA == 'G') return 1 end

    if(charA == 'S') return 5 end 

    if(charA == 'W') return 8 end

    return size(Matrix,1)*size(Matrix,2)*10

end




#######################################################################################################################################################

###
#    Fonction Main qui initialise les differentes structures et appel les fonctions pour utiliser l'agolrithme de Dijsktra
##

#######################################################################################################################################################



function algoDijkstra(file, departur::Tuple{Int64,Int64}, arrival::Tuple{Int64,Int64})

    #recupere la matrice de symbole
    Matrice = toMatrix(file)

    height = size(Matrice,1)

    width = size(Matrice,2)

    #Valeur grand pour initialiser la matrice de cout d'arrive
    M = 10*height*width

    #Matrice de bool definissant si la case a deja ete verifier ou non
    Matrixbool::Matrix{Bool} = fill(false,height,width)

    #Matrice d'entier definissant si le coup pour arriver a la case depuis le depart
    MatrixDistance::Matrix{Int64} = fill(M,height,width)
    MatrixDistance[departur[1],departur[2]] = 0

    #Matrice de point désignant le précedant de chaque point
    MAtrixPrec::Matrix{Tuple{Int64,Int64}} = fill((-1,-1),height,width)

    #queue a priorité pour trouver rapidement le plus petit cout pas encore visite
    pq = PriorityQueue{Tuple{Int64,Int64},Int64}();

    #ajoute l'element de depart dans la queue avec la plus petite priorité
    pq[departur] = 0

   


    
    #verifie si le symbol de depart est possible
    if(cout(departur, Matrice) == -1 || cout(arrival,Matrice) == -1) return("Erreur : point de départ invalide") end

    

   

 
    @time liste::Vector{Tuple{Int64,Int64}} = Dijsktra(Matrice, Matrixbool, MatrixDistance, MAtrixPrec, pq, departur, arrival)

    #affiche la distance
    println("Distance D -> A : ",MatrixDistance[arrival[1],arrival[2]])
   



    Draw(Matrice, liste, Matrixbool)

end 


#######################################################################################################################################################

###
#    Fonction Main qui initialise les differentes structures et appel les fonctions pour utiliser l'agolrithme de A*
##

#######################################################################################################################################################

function algoAstar(file, departur::Tuple{Int64,Int64}, arrival::Tuple{Int64,Int64})

    #recupere la matrice de symbole
    Matrice = toMatrix(file)

    height = size(Matrice,1)

    width = size(Matrice,2)

    #Valeur grand pour initialiser la matrice de cout d'arrive
    M = 10*height*width

    #Matrice de bool definissant si la case a deja ete verifier ou non
    Matrixbool::Matrix{Bool} = fill(false,height,width)

    #Matrice d'entier definissant si le coup pour arriver a la case depuis le depart
    MatrixDistance::Matrix{Int64} = fill(M,height,width)
    MatrixDistance[departur[1],departur[2]] = 0

    #Matrice de point désignant le précedant de chaque point
    MAtrixPrec::Matrix{Tuple{Int64,Int64}} = fill((-1,-1),height,width)

    #queue a priorité pour trouver rapidement le plus petit cout pas encore visite
    pq = PriorityQueue{Tuple{Int64,Int64},Int64}();

    #ajoute l'element de depart dans la queue avec la plus petite priorité
    pq[departur] = 0

   


    
    #verifie si le symbol de depart est possible
    if(cout(departur, Matrice) == -1 || cout(arrival,Matrice) == -1) return("Erreur : point de départ invalide") end

    

   

 
    @time liste::Vector{Tuple{Int64,Int64}} = Astar(Matrice, Matrixbool, MatrixDistance, MAtrixPrec, pq, departur, arrival)

    #affiche la distance
    println("Distance D -> A : ",MatrixDistance[arrival[1],arrival[2]])



    Draw(Matrice, liste, Matrixbool)

end




#######################################################################################################################################################

###
#    Fonction exist qui verifie si un point donnée appartient bien a la matrice
##

#######################################################################################################################################################


function exist(a::Tuple{Int64,Int64},M::Matrix{Char})


    if (a[1] < 1 || a[2] < 1 || a[1] > size(M,1) || a[2] > size(M,2)) return false  end

    return true

end




#######################################################################################################################################################

###
#    Fonction Dijsktra qui retourne une liste contenant les sommet par lequel passe le plus court chemin, si la liste est vide c'est que le chemin n'existe pas
##

#######################################################################################################################################################



function Dijsktra(Matrice::Matrix{Char}, Bool::Matrix{Bool}, Distance::Matrix{Int64}, prec::Matrix{Tuple{Int64,Int64}}, pq::PriorityQueue{Tuple{Int64,Int64},Int64},Departur::Tuple{Int64,Int64}, Arrival::Tuple{Int64,Int64})


    eval::Int64 = 1

    while ! Bool[Arrival[1],Arrival[2]]

        #@show pq


        #recupere le point avec le chemin le plus court (plus basse priorite)
        point::Tuple{Int64,Int64} = dequeue!(pq)

        eval = eval + 1

        #passe le point en 'visite'
        Bool[point[1],point[2]] = true

        if (exist((point[1]+1,point[2]),Matrice))

            

            if (Distance[point[1], point[2]] + cout((point[1]+1,point[2]),Matrice) < Distance[point[1]+1,point[2]] )

                Distance[point[1]+1,point[2]] = Distance[point[1], point[2]] + cout((point[1]+1,point[2]),Matrice)

                prec[point[1]+1,point[2]] = (point[1],point[2])
            end

            if (! Bool[point[1]+1,point[2]])
                pq[(point[1]+1,point[2])] = Distance[point[1], point[2]] + cout((point[1]+1,point[2]),Matrice)
            end

            
        end
        
        if exist((point[1]-1,point[2]),Matrice)

           

            if (Distance[point[1], point[2]] + cout((point[1]-1,point[2]),Matrice) < Distance[point[1]-1,point[2]] )

                Distance[point[1]-1,point[2]] = Distance[point[1], point[2]] + cout((point[1]-1,point[2]),Matrice)

                prec[point[1]-1,point[2]] = (point[1],point[2])
            end

            if (! Bool[point[1]-1,point[2]])
                pq[(point[1]-1,point[2])] = Distance[point[1], point[2]] + cout((point[1]-1,point[2]),Matrice)
            end
           
        end


        if exist((point[1],point[2]+1),Matrice)


            if (Distance[point[1], point[2]] + cout((point[1],point[2]+1),Matrice) < Distance[point[1],point[2]+1] )

                Distance[point[1],point[2]+1] = Distance[point[1], point[2]] + cout((point[1],point[2]+1),Matrice)

                prec[point[1],point[2]+1] = (point[1],point[2])
            end

            if (! Bool[point[1],point[2]+1])
                pq[(point[1],point[2]+1)] = Distance[point[1], point[2]] + cout((point[1],point[2]+1),Matrice)
            end
            
        end

        if exist((point[1],point[2]-1),Matrice)

           

            if (Distance[point[1], point[2]] + cout((point[1],point[2]-1),Matrice) < Distance[point[1],point[2]-1] )

                Distance[point[1],point[2]-1] = Distance[point[1], point[2]] + cout((point[1],point[2]-1),Matrice)

                prec[point[1],point[2]-1] = (point[1],point[2])
            end

            if (! Bool[point[1],point[2]-1])
                pq[(point[1],point[2]-1)] = Distance[point[1], point[2]] + cout((point[1],point[2]-1),Matrice)
            end
            
        end

        

    end


    liste::Vector{Tuple{Int64,Int64}} = []
    etape::Tuple{Int64,Int64} = Arrival

    while etape != Departur

        #println(!exist(etape,Matrice))

        if !exist(etape,Matrice)

            println("Chemin impossible")

            vide::Vector{Tuple{Int64,Int64}} = []

            return vide
        end

        push!(liste,etape)

        etape = prec[etape[1], etape[2]]


    end
    push!(liste,Departur)

    #@show liste

    println("Number of states evaluated :", eval)

    return liste
    

end



#######################################################################################################################################################

###
#    Fonction Astar qui retourne une liste contenant les sommet par lequel passe le plus court chemin, si la liste est vide c'est que le chemin n'existe pas
##

#######################################################################################################################################################


function Astar(Matrice::Matrix{Char}, Bool::Matrix{Bool}, Distance::Matrix{Int64}, prec::Matrix{Tuple{Int64,Int64}}, pq::PriorityQueue{Tuple{Int64,Int64},Int64},Departur::Tuple{Int64,Int64}, Arrival::Tuple{Int64,Int64})

    eval::Int64 = 1

    #Boucle tant que qui s'arrete quand le point d'arrivé est visité
    while ! Bool[Arrival[1],Arrival[2]]

        #@show pq

        #recupere le point (point d'étude) avec le chemin le plus court (plus basse priorite)
        point::Tuple{Int64,Int64} = dequeue!(pq)

        eval = eval + 1
        

        #passe le point en 'visite'
        Bool[point[1],point[2]] = true

        #verifie si le point qu'on regarde existe bien
        if (exist((point[1]+1,point[2]),Matrice))

            
            #Verifie si la distance pour allez a ce point depuis le point de depart en passant par le point d'étude est le plus rapide 
            if (Distance[point[1], point[2]] + cout((point[1]+1,point[2]),Matrice) < Distance[point[1]+1,point[2]] )

                #Cgange la distance en la nouvelle plus courte
                Distance[point[1]+1,point[2]] = Distance[point[1], point[2]] + cout((point[1]+1,point[2]),Matrice)

                #mets donc a jour le le precedent du point pour trouvé son plus cours chemin
                prec[point[1]+1,point[2]] = (point[1],point[2])
            end

            
            #Verifie si le point n'a pas encore ete point d'étude
            if (! Bool[point[1]+1,point[2]])

                #mets dans la priority queue le  point avec comme priorité la distance du chemin depuis le poit de depart plus l'heuristique (estimation du temps d'arrivé)
                pq[(point[1]+1,point[2])] = (Distance[point[1], point[2]] + cout((point[1]+1,point[2]),Matrice)) + abs((Arrival[1]-point[1]+1 ) + (Arrival[2] - point[2]))

            end

            
        end
        
        if exist((point[1]-1,point[2]),Matrice)

           

            if (Distance[point[1], point[2]] + cout((point[1]-1,point[2]),Matrice) < Distance[point[1]-1,point[2]] )

                Distance[point[1]-1,point[2]] = Distance[point[1], point[2]] + cout((point[1]-1,point[2]),Matrice)

                prec[point[1]-1,point[2]] = (point[1],point[2])
            end

            if (! Bool[point[1]-1,point[2]])

                #mets dans la priority queue le  point avec comme priorité la distance du chemin depuis le poit de depart plus l'heuristique (estimation du temps d'arrivé)
                pq[(point[1]-1,point[2])] = (Distance[point[1], point[2]] + cout((point[1]-1,point[2]),Matrice)) + abs((Arrival[1]-point[1]-1 ) + (Arrival[2] - point[2]))

            end
           
        end


        if exist((point[1],point[2]+1),Matrice)


            if (Distance[point[1], point[2]] + cout((point[1],point[2]+1),Matrice) < Distance[point[1],point[2]+1] )

                Distance[point[1],point[2]+1] = Distance[point[1], point[2]] + cout((point[1],point[2]+1),Matrice)

                prec[point[1],point[2]+1] = (point[1],point[2])
            end

            if (! Bool[point[1],point[2]+1])

                #mets dans la priority queue le  point avec comme priorité la distance du chemin depuis le poit de depart plus l'heuristique (estimation du temps d'arrivé)
                pq[(point[1],point[2]+1)] = (Distance[point[1], point[2]] + cout((point[1],point[2]+1),Matrice)) + abs((Arrival[1]-point[1] ) + (Arrival[2] - point[2]+1))

            end
            
        end

        if exist((point[1],point[2]-1),Matrice)

           

            if (Distance[point[1], point[2]] + cout((point[1],point[2]-1),Matrice) < Distance[point[1],point[2]-1] )

                Distance[point[1],point[2]-1] = Distance[point[1], point[2]] + cout((point[1],point[2]-1),Matrice)

                prec[point[1],point[2]-1] = (point[1],point[2])
            end

            if (! Bool[point[1],point[2]-1])

                #mets dans la priority queue le  point avec comme priorité la distance du chemin depuis le poit de depart plus l'heuristique (estimation du temps d'arrivé)
                pq[(point[1],point[2]-1)] = (Distance[point[1], point[2]] + cout((point[1],point[2]-1),Matrice)) + abs((Arrival[1]-point[1]) + (Arrival[2] - point[2]-1))

            end
            
        end

        

    end


    liste::Vector{Tuple{Int64,Int64}} = []
    etape::Tuple{Int64,Int64} = Arrival

    while etape != Departur

        #println(!exist(etape,Matrice))

        if !exist(etape,Matrice)

            println("Chemin impossible")

            vide::Vector{Tuple{Int64,Int64}} = []

            return vide
        end

        push!(liste,etape)

        etape = prec[etape[1], etape[2]]


    end
    push!(liste,Departur)

    #@show liste

    println("Number of states evaluated :", eval)

    return liste
    

end


#######################################################################################################################################################

###
#    Fonction Draw qui dessine la matrice avec les chemin en rouge si il existe
##

#######################################################################################################################################################

#Dictionnaire convertissant un symbole en RGB
function Draw(M::Matrix{Char}, l::Vector{Tuple{Int64,Int64}}, Visite::Matrix{Bool})

    toColor::Dict{Char,Vector{Int64}} = Dict('.' => [255,255,255], 
                                             'G' => [20,148,20] ,
                                             'S' => [254,248,108],
                                             'W' => [0,127,255],
                                             '@' => [0,0,0],
                                             'O' => [0,0,0],
                                             'T' => [9,82,40]
    )

    Color::Matrix{Vector{Int64}} = fill([0,0,0],size(M,1),size(M,2))



    #Parcours de la matrice de symbole pour mettre les couleurs correspondantes dans la mtracide de couleur
    for i in 1:size(M,1)
        for j in 1:size(M,2)

            #Si la case a été visité par l'algorithme elle sera colorié en jaune sinon elle prendra la couleur correspondante a son symbole
            if(Visite[i,j]) Color[i,j] = [255,0,255] else Color[i,j] = toColor[M[i,j]] end
            
        end
    end


    
    #PArcours de la liste des points du chemin pour les mettres d'une couleur differentes
    for i in 1:size(l,1)

        Color[l[i][1],l[i][2]] = [255,0,0]

    end


    #fonction qui affiche en immage la matrice de RGB
    imshow(Color)

end