program check
  implicit none
  integer,parameter:: ndatos=10000
  real:: int,esp(ndatos),a,b
  integer,parameter::n=1e5
  real,dimension(10000)::div,frec,ord
  integer:: i,j,l,mayor,aux,ndim


  
  
  open(20,file='histograma_0.0500.txt')
  open(30,file='Especies_posicion_0.0500000.txt')
  read(30,*)
  do i=1,ndatos
     read(30,*) a,b,esp(i)
  end do
  
  ndim=maxval(esp)
  
  ! inicializo las variables
  do i=1,ndim
     frec(i)=0
     div(i)=i
  end do
  

   !encuentro la frecuencia de cada numero y la guardo en frec(i)
do l=1,ndatos
      do j=2,ndim-1
        ! si el numero cae dentro de alguna de las divisiones del intervlao (0,1), sumo uno a la frecuencia
        if ((div(j-1)<esp(l)).and.(esp(l)<div(j+1))) then
           frec(j)=frec(j)+1
           ord(j)=frec(j)          
        end if
     end do
     
  end do

  
  ! encuentro el mayor de la frecuencia para despues dividir
  do i=1 ,ndim
     do j=1,ndim-i
        if (ord(j)<ord(j+1)) then
        
           aux=ord(j)
           ord(j)=ord(j+1)
           ord(j+1)=aux
           
        end if
     end do
  end do

! normalizo al mayor
do i=1,ndim
   frec(i)=frec(i)/ord(ndim)
end do

! guardo en un archivo el intervalo en el que cae el número, div(l) y la frecuencia
  do l=1,ndim
     write(20,*) div(l),ord(l)
  end do
       
  close(20)
  close(30)
  close(40)
  


end program check
    
