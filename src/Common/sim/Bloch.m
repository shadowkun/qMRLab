function dM = Bloch(t, M, Param, Pulse)
%BLOCH Bloch-McConnell ordinary differential equations.
%   dM = Bloch(t, M, Param, Pulse)
%
%   --args--
%   t: Function handle variable, represents the time.
%   M : magnetization vector [Mxf, Myf, Mzf, Mzr]
%   Param: Tissue parameter structure.
%
%          -fields-
%          M0f: Free pool equilibrium magnetization.
%          M0r: Restricted pool equilibrium magnetization. (M0r = F*M0f)
%          R1f: Free pool longitudinal relaxation rate.
%          R1r: Restricted pool longitudinal relaxation rate.
%          R2f: Free pool transverse relaxation rate.
%          kf: Free pool magnetization exchange rate. 
%          kr: Restricted pool magnetization exchange rate. (= kf/F)
%          G: Lineshape value of the restricted pool (generated by
%             computeG.m)
%
%   Pulse: RF Pulse structure (generated by GetPulse.m).
%
%   Reference: R. Mark Henkelman, Xuemei Huang, Qing-San Xiang, G. J. 
%               Stanisz, Scott D. Swanson, Michael J. Bronskill. 
%               Quantitative Interpretation of Magnetization Transfer,Mag. 
%               Res. in Med., 29, 759-766, Eqs. 1-6, (1993)
%
%
%   See also COMPUTEG, GETPULSE, BLOCH, BLOCHNOMT.
% 

dM = zeros(4,1);

if (nargin < 4)
    omega  = 0;
    omega2 = 0;
    delta  = 0;
else
    omega  = Pulse.omega(t);
    omega2 = Pulse.omega2(t);
    delta  = Pulse.delta;
end

W = pi*Param.G.*omega2;

if isfield(Param,'T2f')
    R2f = 1./Param.T2f;
else
    R2f = Param.R2f;
end

if isfield(Param,'F')
    kf = Param.kr*Param.F;
    M0r = Param.M0f*Param.F;
else
    kf = Param.kf;
    M0r = Param.M0r;
end

dM(1) = -R2f*M(1) - 2*pi*delta*M(2);
dM(2) = -R2f*M(2) + 2*pi*delta*M(1) + omega*M(3);
dM(3) =  Param.R1f*(Param.M0f-M(3)) - kf*M(3) + Param.kr*M(4) - omega*M(2);
dM(4) =  Param.R1r*(M0r-M(4)) + kf*M(3) - Param.kr*M(4) - W*M(4);

end
