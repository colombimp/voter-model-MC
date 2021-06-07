! programa que calcula las correlaciones espaciales
program corre
  implicit none
 ! s=d*d=tamaño de la red
    integer,parameter::s=10000,d=100
    integer::i,j,x,y,m(s),k,p,l,npares(0:d-1),coordx(s),coordy(s)
    real::corr(0:d-1),F(0:d-1),nu,r
    character(len=60)::nombre_archivo1,nombre_archivo2,correlaciones

    write(*,*) 'ingresar nu'
    read(*,*) nu
      
    corr(:)=0
    npares(:)=0
    m(:)=0
    F(:)=0
    ! creo el archivo donde voy a guardar las correlaciones calculadas
    write(correlaciones,"(a,f9.7,a)") 'correlaciones_',nu,'.txt'
    open(30,file=correlaciones)
    
    ! abro el archivo con los datos de la magnetización por tamaño de red como función del tiempo, sacado del programa de montecarlo para ising de la practica anterior
    
    write(nombre_archivo1,"(a,f9.7,a)") 'Especies_posicion_',nu,'.txt'
    open(20,file=nombre_archivo1)

    ! salteo la primera fila
    
    read(20,*)

    do i=1,s
       read(20,*) coordx(i),coordy(i),m(i)
    end do

    ! calculo el número de pares separados una distancia k.
    do i=1,d
       do j=1,d
          do p=1,d
             do l=1,d
                do k=0,floor(d/sqrt(2.))
                   ! la función bin(i,j,d) calcula la distancia al cuadrado entre i, y j, teniendo en cuenta las condiciones periódicas de contorno
                   r=sqrt(bin(i,j,d)**2+bin(p,l,d)**2)
                   if (floor(r)==k) then
                      npares(k)=npares(k)+1
                   end if
                end do
             end do
          end do
       end do
    end do

       ! corr(k) guarda la suma de los productos de individuos de la misma especie separados una distancia r           
    do k=0,floor(d/sqrt(2.))
       do i=1,s
          do j=1,s
             r=sqrt(bin(coordx(i),coordx(j),d)**2+bin(coordy(i),coordy(j),d)**2)
             if ((floor(r)==k).and.(m(i)==m(j))) then
                 corr(k)=corr(k)+1
             end if
          end do
       end do
    end do

    ! divido corr(k) con npares(k)
    do k=0,floor(d/sqrt(2.))       
       F(k)=corr(k)/(npares(k))
    end do

   
    ! guardo la correlación a partir de x=1 y la distancia en un archivo, no guardo F(0)
    do i=1,floor(d/sqrt(2.))
       write(30,*) i,F(i)
    end do
    close(20)
    close(30)
    close(40)

  contains
    
    !función que calcula la distancia entre 2 puntos, si es mayor que d/2 (la mitad del lado de la red), me devuelve d-distancia, para tener en cuenta las condiciones de borde periódicas.
    
    real function bin(x0,x,d)
      integer::x,y,x0,y0,d
      real:: distx

      distx=abs(x-x0)
      bin=distx
      
      if (distx>(d/2)) then
         bin=(d-distx)
      end if
      
    end function bin
    
    
  end program corre

  
   
