C      TMWN JULY 94
C      Savitsky Golay smoothing subroutines.
C      Taken from "Numerical Recipes" by Flannery and Press.
C      Stored here in a separate file to assist debugging.

      SUBROUTINE savgol(c,np,nl,nr,ld,m)
C     Savitsky Golay smoothing.
C     Taken from Numerical Recipes, Flannery and Press.
C     Calculates coefficients for linear smoothing,
C     such that higher moments are preserved.
C     Re. correlation function analysis, smoothing used
C     to ease the join between calc. and expt. data.
      INTEGER ld,m,nl,np,nr,mmax
      REAL c(np)
      PARAMETER (mmax=6)
      INTEGER imj,ipj,j,k,kk,mm,indx(mmax+1)
      REAL d,fac,sum,a(mmax+1,mmax+1),b(mmax+1)

      
      IF (np.LT.nl+nr+1.OR.nl.LT.0.OR.nr.LT.0.OR.ld.GT.m.OR.m.GT.mmax
     +.OR.nl+nr.LT.m) PAUSE 'Bad arguments passed to subroutine savgol'

      DO ipj=0,2*m
        sum=0.
        IF (ipj .EQ. 0) sum=1.

        DO k=1,nr
          sum=sum+FLOAT(k)**ipj
        END DO

        DO k=1,nl
          sum=sum+FLOAT(-k)**ipj
        END DO

        mm=MIN(ipj,2*m-ipj)
        DO imj=-mm,mm,2
          a(1+(ipj+imj)/2,1+(ipj-imj)/2)=sum
        END DO
      END DO

      CALL ludcmp(a,m+1,mmax+1,indx,d)

      DO j=1,m+1
        b(j)=0.
      END DO
      b(ld+1)=1

      CALL lubksb(a,m+1,mmax+1,indx,b)

      DO kk=1,np
        c(kk)=0.
      END DO

      DO k=-nl,nr
        sum=b(1)
        fac=1.
        DO mm=1,m
          fac=fac*k
          sum=sum+b(mm+1)*fac
        END DO
        kk=MOD(np-k,np)+1
        c(kk)=sum
      END DO

      RETURN
      END



      SUBROUTINE ludcmp(a,n,np,indx,d)
C     LU decomposition.
C     Taken from Numerical Recipes, Flannery and Press.
C     Used by subroutine savgol.
      INTEGER n,np,indx(n),nmax
      REAL d,a(np,np),tiny
      PARAMETER (nmax=500,tiny=1.E-8)
      INTEGER i,imax,j,k 
      REAL aamax,dum,sum,vv(nmax)

      d=1.
      DO i=1,n
        aamax=0.
        DO j=1,n
          IF (ABS(a(i,j)) .GT. aamax) aamax=ABS(a(i,j))
        END DO
        IF (aamax .EQ. 0.) PAUSE 'Singular matrix in subroutine ludcmp'
        vv(i)=1./aamax
      END DO
      
      DO j=1,n
        DO i=1,j-1
          sum=a(i,j)
          DO k=1,i-1
            sum=sum-a(i,k)*a(k,j)
          END DO
          a(i,j)=sum
        END DO
        aamax=0.
        DO i=j,n
          sum=a(i,j)
          DO k=1,j-1
            sum=sum-a(i,k)*a(k,j)
          END DO
          a(i,j)=sum
          dum=vv(i)*ABS(sum)
          IF (dum .GE. aamax) THEN
            imax=i
            aamax=dum
          ENDIF
        END DO
        IF (j .NE. imax) THEN
          DO k=1,n
            dum=a(imax,k)
            a(imax,k)=a(j,k)
            a(j,k)=dum
          END DO
          d=-d
          vv(imax)=vv(j)
        ENDIF
        indx(j)=imax
        IF (a(j,j) .EQ. 0.) a(j,j)=tiny
        IF (j .NE. n) THEN
          dum=1./a(j,j)
          DO i=j+1,n
            a(i,j)=a(i,j)*dum
          END DO
        ENDIF
      END DO
      
      RETURN
      END



      SUBROUTINE lubksb(a,n,np,indx,b)
C     Subroutine associated with LU decomposition.
C     Taken from "Numerical Recipes" Flannery and Press.
C     Used in Savitsky Golay smoothing.
      INTEGER n,np,indx(n)
      REAL a(np,np),b(n)
      INTEGER i,ii,j,ll
      REAL sum
      ii=0
      DO i=1,n
        ll=indx(i)
        sum=b(ll)
        b(ll)=b(i)
        IF (ii .NE. 0) THEN
          DO j=ii,i-1
            sum=sum-a(i,j)*b(j)
          END DO
        ELSEIF (sum .NE. 0.) THEN
          ii=i
        ENDIF
        b(i)=sum
      END DO
      DO i=n,1,-1
        sum=b(i)
        DO j=i+1,n
          sum=sum-a(i,j)*b(j)
        END DO
        b(i)=sum/a(i,i)
      END DO

      RETURN
      END
