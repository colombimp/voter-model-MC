5#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Nov  5 15:08:00 2019

@author: mariapapla
"""
import numpy as np
import matplotlib.pyplot as plt
import glob
import scipy
from scipy.optimize import curve_fit


# levanto todos los archivos que empiezan con 'correlaciones_' y terminan con '100x100.txt'
archivos=sorted(glob.glob('correlaciones_*.txt'))
# defino funcion a ajustar
def bessel(x,b,a):
    return a*scipy.special.kn(0, x*b)

nu=np.zeros(len(archivos))
corre=np.zeros(len(archivos))
k=np.zeros(len(archivos))
ajuste=np.zeros(len(archivos))
for i in range(len(archivos)):
# leo la probabilidad del nombre de cada archivo
     nu[i]=archivos[i][14:23]
# leo de cada archivo la correlacion espacial y la guardo en el array corre a cada punto x
     x,bdiv=np.loadtxt(''.join(['correlaciones_',archivos[i][14:23],'.txt',]),unpack='true')
    # realizo el ajuste 
     popt, pcov = curve_fit(bessel, x, bdiv)#,bounds=(0,1e10))   
   # guardo el valor de k en un vector
     k[i]=popt[0]
     
     plt.xlabel('Distancia')
     plt.ylabel('Beta diversidad')
     plt.plot(x, bessel(x, *popt), 'k-',label='Ajuste')
     print(popt[0],nu[i])
     plt.plot(x,bdiv,'.',label=''.join(['Beta diversidad nu=',archivos[i][14:20]]))
     plt.legend(loc='upperleft')
     plt.grid(color='k', linestyle='--', linewidth=0.5)
     
     plt.savefig('ajustes.pdf')  
   #guardo nu y el valor de k en un txt
     np.savetxt("k_nu.txt", np.transpose([nu,k]))   
     

     
    
