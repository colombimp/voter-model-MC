program ej2
  implicit none
  ! comienzo con un numero incial de ninic=300 especies distintas, y una red de 100x100

  integer,parameter:: d=100,s=10000,ninic=300,tmax=1e6,nindmax=100000
  integer::m(d,d),i,j,k,i0,j0,l,p,vecino,nind(nindmax),a,nactual
  integer,dimension(d)::e,o,n,sur
  real:: nu,rs(s),prob,r(s),ri0,rj0,rvecino
  character(len=37)::nombre_archivo1,nombre_archivo2
  

  write(*,*) 'Ingrese la probabilidad nu'
  read(*,*) nu
  
  ! genero un vector rs con s numeros al azar.  
  call ranmar(rs,s)

  ! los rescaleo para que sean enteros entre 1 y ninc=300, y los almaceno en el vector r. Cada elemento representa un individuo de la especie sorteada.

  do i=1,s
     r(i)=floor(ninic*rs(i)+1) 
  end do

  
  !en la matriz m(i,j) guardo el estado de la red y en el elemento i del vector nind guardo la cantidad de individuos de la especie i (abundancia).
  nind(:)=0
  
  do i=1,d
     do j=1,d
        m(i,j)=r(d*(i-1)+j)
        nind(m(i,j))=nind(m(i,j))+1
     end do    
  end do 
 
  ! defino indirecciones para dar las condiciones de contorno
  
  do i=1,d-1
     e(i)=1
     sur(i)=1
     o(i+1)=-1
     n(i+1)=-1
  end do
  e(d)=1-d
  o(1)=d-1
  n(1)=d-1
  sur(d)=1-d

 
  !---------------------------------------------------

    
    ! abro los archivos donde voy a guardar el estado final de la red y elnumero de especies como funcion del tiempo.
    write(nombre_archivo1,"(a,f9.7,a)") 'Especies_posicion_',nu,'.txt'
    write(nombre_archivo2,"(a,f9.7,a)") 'Nro_especies_t_',nu,'.txt'
    
    open(30,file=nombre_archivo1)
    open(50,file=nombre_archivo2)

    
    write(30,'(a)') ' Coordenada x  Coordenada y     Especie'
    write(40,'(a)') 'Etiqueta especie    N° indiviuos'

    
    do k=1,tmax
       ! corro s=100x100 pasos
       do i=1,s
     
          ! elijo un individuo random m(i0,j0) para remover, j0,i0 enteros aleatorio etre 1 y d
          call ranmar(ri0,1)
          call ranmar(rj0,1)
       
          i0=floor(d*ri0)+1
          j0=floor(d*rj0)+1
         
          ! genero un numero aleatorio prob, con 0<prob<1
          call ranmar(prob,1)
          ! reduzco en 1 el numero de individuos de la especie sorteada
          nind(m(i0,j0))=nind(m(i0,j0))-1

          if (nu>prob) then
             
                ! Creo una especie nueva. Para eso voy a usar la etiqueta de alguna especie que ya haya muerto, buscando en el vector nind si hay algun elemento que valga cero.
                a=0
                j=0                
                do while ((a==0).and.(j<=nindmax))
                   j=j+1
                   if ((nind(j)==0).and.(m(i0,j0)/=j)) then
                      ! creo un individuo en este lugar, y sumo 1 a su abundancia
                      m(i0,j0)=j
                      nind(j)=nind(j)+1
                      a=1  
                   end if
                end do
                
             else if (nu<prob) then
  
                ! genero un numero aleatorio entero entre 1 y 4, rvecino
                call ranmar(rvecino,1)
               
                vecino=floor(4*rvecino+1)
                
                ! 1 es el vecino norte, 2 es este, 3 es sur, 4 es oeste. El que haya salido es el que va a reemplazar al individuo m(i0,j0)
                if (vecino==1) then
                   m(i0,j0)=m(i0+n(i0),j0)
                else if (vecino==2) then
                   m(i0,j0)=m(i0,j0+e(j0))
                else if (vecino==3) then
                   m(i0,j0)=m(i0+sur(i0),j0)
                else if (vecino==4) then
                   m(i0,j0)=m(i0,j0+o(j0))
                end if

                ! aumento en 1 el numero de individuos de la especie que reemplazo al original
                nind(m(i0,j0))=nind(m(i0,j0))+1
             end if
          end do

          ! leo el número de especies actual de la cantidad de elementos distintos de cero del vector nind, y lo guardo como función del tiempo de Montecarlo k.
          nactual=0
          if (mod(k,500)==0) then
             do j=1,nindmax
                if (nind(j)/=0) then
                   nactual=nactual+1
                end if     
             end do
             write(50,*) k,nactual
          end if
             
    end do
    ! guardo el estado de la red
    do j=1,d
       do l=1,d
          write(30,*) l,j,m(l,j)
       end do
    end do

    
       close(30)
       close(50)
         
end program ej2

     
