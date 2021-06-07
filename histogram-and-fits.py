#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  2 09:21:30 2019

@author: mariapapla
"""
import numpy as np
import matplotlib.pyplot as plt
import glob
from scipy.optimize import curve_fit

frecuencias=np.zeros(1)
abundancia=np.zeros(1)
archivos=sorted(glob.glob('histograma_*.txt'))

# genero histogramas para la abundancia
for i in range(len(archivos)): 
    esp,frec=np.loadtxt(''.join(['histograma_',archivos[i][11:17],'.txt']),unpack='true')
    
    plt.bar(esp,frec,label=''.join(['Abundancia especies nu=',archivos[i][12:17]]))
    plt.xlabel('Especie')
    plt.ylabel('Nro de individuos')
    plt.legend()
    plt.grid(color='k', linestyle='--', linewidth=0.5)
     
    plt.savefig(''.join(['histograma_',archivos[i][14:17],'.png']))
    plt.show()
   
# defino las funciones a ajustar    
def ex(x,b,c,a,d):
    return a*(x**b)*(np.exp(-x*c))
def ajuste(x,alfa,a):
    return a*(x**(-alfa))

# ajusto una función tipo potencia*exponencial a la abundancia
    
for i in range(len(archivos)):
    
    esp,frec=np.loadtxt(''.join(['histograma_',archivos[i][11:17],'.txt']),unpack='true')
    
    popt, pcov = curve_fit(ex, esp, frec)
    
    plt.plot(esp,ex(esp,*popt),'b-',label='Ajuste') 
    plt.plot(esp,frec,'r.',label=''.join(['Abundancia especies nu=',archivos[i][12:17]]))
    plt.ylabel('Nro de individuos')
    plt.xlabel('Especie')
    plt.legend()
    plt.grid(color='k', linestyle='--', linewidth=0.5)
    print(popt[0])
    plt.savefig(''.join(['Ajuste_abundancia_',archivos[i][12:17],'.png']))
    plt.show()


# ajusto una función tipo potencia a el exponente como función de nu    
nu,b,c=np.loadtxt('exponentes.txt',unpack='true')
popt, pcov = curve_fit(ajuste, nu, c)
x=np.array([0.,0.0001,0.0005,0.001,0.003,0.005,0.007,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1])
plt.plot(x,ajuste(x,*popt),'b-',label='Ajuste') 
plt.plot(nu,c,'r.',label='Exponente')
plt.xlabel('Probabilidad')
plt.ylabel('Exponente')
plt.legend()
print(popt[0])
plt.grid(color='k', linestyle='--', linewidth=0.5)

plt.savefig('nu_c.pdf')

'colormap de especies'

x,y,tagesp = np.loadtxt('Especies_posicion_0.1000000.txt',unpack='true')

posiciones =  [x,y]

plt.figure(figsize=(7, 6))
plt.pcolormesh(posiciones)
plt.colorbar()

plt.show()  
