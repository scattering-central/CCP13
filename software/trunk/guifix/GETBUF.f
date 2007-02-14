      subroutine GETBUF(BUF1,BUF2,NPIX,NRAST)

      integer NPIX,NRAST 
      real BUF1(NPIX*NRAST),BUF2(NPIX*NRAST)

      do 10 i=1,NPIX*NRAST
        BUF2(I)=BUF1(I)
10    continue

      return
      end
