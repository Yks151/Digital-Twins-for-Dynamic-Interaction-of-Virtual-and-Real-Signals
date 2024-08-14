%Õ‚»¶À…À
function dx=vdp1004(t,x)
din=50;dout=80;alfa=10/pi*180;d=16;dm=72;Cr=1e-3;Z=8;fs=500;B=3;C=80;m=0.1;
D=65;fai0=0;kin=2000;kout=1000;Fx=100;Fy=60;
rin=din/2;rout=dout/2;sum1=0;sum2=0;
fin=rin/d;fout=rout/d;gama=d*cosd(alfa)/dm;
pin=1/d*(4-1/fin+2*gama/(1-gama));
pout=1/d*(4-1/fout+2*gama/(1+gama));
omeigas=2*pi*fs;omeigac=(1-d/D)*omeigas/2;
faiqn=B/rin;
faiqo=B/rout;
Hmax=d/2-sqrt((d/2)^2-(B/2)^2);
for i=1:Z
    sitao=2*pi*(i-1)/Z+omeigac*t;
    sitan=2*pi*(i-1)/Z+(omeigac-omeigas)*t;
    faid=2*pi/Z*(i-1)+omeigac*t;
    if 0<=mod(faid,2*pi)-fai0<=faiqo
        Hf=Hmax*sind(pi/faiqo*(mod(faid,2*pi)-fai0));
    else
        Hf=0;
    end
     det1=(x(1)*sind(sitao)+x(3)*cosd(sitao)-(Cr+Hf))^3/2*sind(sitao);
     det2=(x(1)*sind(sitao)+x(3)*cosd(sitao)-(Cr+Hf))^3/2*cosd(sitao);
     sum1=sum1+det1;
     sum2=sum2+det2;
end
dx=zeros(4,1);
dx(1)=x(2);
dx(3)=x(4);
dx(2)=(Fx-kout*sum1-C*x(2))/m;
dx(4)=(Fy-kout*sum2-C*x(3))/m;