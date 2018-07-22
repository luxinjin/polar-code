function updateL(lambda,phi)
    global LB;
    n = LB.n;
    if lambda == 0
        return;
    end
    psi = floor(phi/2);
    if mod(phi,2)==0
        updateL(lambda-1,psi);
    end
    for omega=0:2^(n-lambda)-1
        if mod(phi,2)==0
            %do sth
            LB.L(phi+omega*2^lambda+1,n+1-lambda) = fFunction(LB.L(psi+2*omega*2^(lambda-1)+1,n+2-lambda),LB.L(psi+(2*omega+1)*2^(lambda-1)+1,n+2-lambda));
        else
            %do sth
            if LB.B(phi-1+omega*2^(lambda)+1,n+1-lambda) == 0
                LB.L(phi+omega*2^(lambda)+1,n+1-lambda) = LB.L(psi+(2*omega+1)*2^(lambda-1)+1,n+2-lambda)+LB.L(psi+(2*omega)*2^(lambda-1)+1,n+2-lambda);
            else
                LB.L(phi+omega*2^(lambda)+1,n+1-lambda) = LB.L(psi+(2*omega+1)*2^(lambda-1)+1,n+2-lambda)-LB.L(psi+(2*omega)*2^(lambda-1)+1,n+2-lambda);
            end
        end
    end
end
