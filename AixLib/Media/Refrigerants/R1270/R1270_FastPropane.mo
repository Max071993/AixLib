within AixLib.Media.Refrigerants.R1270;
package R1270_FastPropane
  "Refrigerant model developed by Sangi et al. for R1270 using a hybrid 
  approach"

  /*Provide basic definitions of the refrigerant. Therefore, fill constants
    or parameters and may add new constants or parameters if needed. Moreover,
    provide references within the information of the package.
  */
  constant Modelica.Media.Interfaces.PartialTwoPhaseMedium.FluidConstants[1]
    refrigerantConstants(
     each chemicalFormula = "C3H8",
     each structureFormula = "C3H8",
     each casRegistryNumber = "74-98-6",
     each iupacName = "Propane",
     each molarMass = 0.04409562,
     each criticalTemperature = 369.89,
     each criticalPressure = 4.2512e6,
     each criticalMolarVolume = 5e3,
     each normalBoilingPoint = 231.036,
     each triplePointTemperature = 85.525,
     each meltingPoint = 85.45,
     each acentricFactor = 0.153,
     each triplePointPressure = 0.00017,
     each dipoleMoment = 0.1,
     each hasCriticalData=true) "Thermodynamic constants for Propane";

  /*Provide basic information about the refrigerant. These basic information
    are the refrigerant name as well as the valid refrigerant limits in terms of
    specific enthalpy, density, absolute pressure and temperature.
  */
  extends AixLib.Media.Refrigerants.Interfaces.PartialHybridTwoPhaseMedium(
    mediumName="Propane",
    substanceNames={"Propane"},
    singleState=false,
    SpecificEnthalpy(
      start=1.0e5,
      nominal=1.0e5,
      min=177e3,
      max=576e3),
    Density(
      start=500,
      nominal=529,
      min=0.77,
      max=547),
    AbsolutePressure(
      start=1e5,
      nominal=5e5,
      min=0.5e5,
      max=30e5),
    Temperature(
      start=273.15,
      nominal=273.15,
      min=263.15,
      max=343.15),
    smoothModel=true,
    onePhase=false,
    ThermoStates=Choices.IndependentVariables.phX,
    fluidConstants=refrigerantConstants);
    /*The vector substanceNames is mandatory, as the number of
      substances is determined based on its size. Here we assume
      a single-component medium.
      singleState is true if u and d do not depend on pressure, but only
      on a thermal variable (temperature or enthalpy). Otherwise, set it
      to false.
      For a single-substance medium, just set reducedX and fixedX to true,
      and there's no need to bother about medium compositions at all. Otherwise,
      set final reducedX = true if the medium model has nS-1 independent mass
      fraction, or reducedX = false if the medium model has nS independent
      mass fractions (nS = number of substances).
      If a mixture has a fixed composition set fixedX=true, otherwise false.
      The modifiers for reducedX and fixedX should normally be final
      since the other equations are based on these values.
      
      It is also possible to redeclare the min, max, and start attributes of
      Medium types, defined in the base class Interfaces.PartialMedium
      (the example of Temperature is shown here). Min and max attributes
      should be set in accordance to the limits of validity of the medium
      model, while the start attribute should be a reasonable default value
      for the initialization of nonlinear solver iterations.
    */

  //redeclare record extends ThermodynamicState "Thermodynamic state"
  //  Density d "Density";
  //  Temperature T "Temperature";
  //  AbsolutePressure p "Pressure";
  //  SpecificEnthalpy h "Enthalpy";
  //end ThermodynamicState;
  /*The record "ThermodynamicState" contains the input arguments
    of all the function and is defined together with the used
    type definitions in PartialMedium. The record most often contains two of the
    variables "p, T, d, h" (e.g., medium.T)
  */

  redeclare replaceable model extends BaseProperties(
    h(stateSelect=StateSelect.prefer),
    d(stateSelect=StateSelect.default),
    T(stateSelect=StateSelect.default),
    p(stateSelect=StateSelect.prefer)) "Base properties of refrigerant"

    Integer phase(min=0, max=2, start=1)
    "2 for two-phase, 1 for one-phase, 0 if not known";
    SaturationProperties sat(Tsat(start=300.0), psat(start=1.0e5))
    "Saturation temperature and pressure";

  equation
    MM = fluidConstants[1].molarMass;
    phase = if ((h < bubbleEnthalpy(sat) or h > dewEnthalpy(sat)) or p >
          fluidConstants[1].criticalPressure) then 1 else 2;
    phase = state.phase;

    d = state.d; //density_ph(p=p,h=h,phase=phase);
    T = state.T; //temperature_ph(p=p,h=h,phase=phase);
    d = density_ph(p=p,h=h,phase=phase);
    T = temperature_ph(p=p,h=h,phase=phase);
    p = state.p; //pressure_dT(d, T, phase);
    h = state.h; //specificEnthalpy_dT(d, T, phase);

    sat.Tsat = saturationTemperature(p=p);
    sat.psat = p; //saturationPressure(T=T);

    u = h - p/d;
    R = Modelica.Constants.R/MM;
  end BaseProperties;
  /*Provide an implementation of model BaseProperties,
    that is defined in PartialMedium. Select two independent
    variables from p, T, d, u, h. The other independent
    variables are the mass fractions "Xi", if there is more
    than one substance. Provide 3 equations to obtain the remaining
    variables as functions of the independent variables.
    It is also necessary to provide two additional equations to set
    the gas constant R and the molar mass MM of the medium.
    Finally, the thermodynamic state vector, defined in the base class
    Interfaces.PartialMedium.BaseProperties, should be set, according to
    its definition (see ThermodynamicState below).
    The computation of vector X[nX] from Xi[nXi] is already included in
    the base class Interfaces.PartialMedium.BaseProperties, so it should not
    be repeated here.

    The code fragments above are for a single-substance medium with
    p,T as independent variables.
  */

  /*Provide records thats contain the fitting coefficients for all fitted
    formula (e.g. Helmholtz equation of state).
  */
  redeclare record EoS
    "Record that contains fitting coefficients of the Helmholtz EoS"
    extends AixLib.DataBase.Media.Refrigerants.R1270.EoS_Sangi;
  end EoS;

  redeclare record BDSP
    "Record that contains fitting coefficients of the state properties at bubble
    and dew lines"
    extends AixLib.DataBase.Media.Refrigerants.R1270.BDSP_Sangi;
  end BDSP;

  redeclare record TSP
    "Record that contains fitting coefficients of the state properties
    calculated with two independent state properties"
    extends AixLib.DataBase.Media.Refrigerants.R1270.TSP_Sangi;
  end TSP;

  /*Provide functions to calculate further thermodynamic properties like the
    dynamic viscosity or thermal conductivity. Also add references.
  */
  redeclare function extends dynamicViscosity
  "Calculates dynamic viscosity of refrigerant"

  protected
      Real tv[:] = {0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 2.0, 2.0, 2.0, 3.0, 4.0, 1.0, 2.0};
      Real dv[:] = {1.0, 2.0, 3.0, 13.0, 12.0, 16.0, 0.0, 18.0, 20.0, 13.0, 4.0, 0.0, 1.0};
      Real nv[:] = {-0.7548580e-1, 0.7607150, -0.1665680, 0.1627612e-5, 0.1443764e-4, -0.2759086e-6, -0.1032756, -0.2498159e-7, 0.4069891e-8, -0.1513434e-5, 0.2591327e-2, 0.5650076, 0.1207253};

      Real T_crit = fluidConstants[1].criticalTemperature;
      Real d_crit = fluidConstants[1].criticalMolarVolume;
      Real MM = fluidConstants[1].molarMass;
      Real R = Modelica.Constants.R/MM;

      ThermodynamicState dewState = setDewState(setSat_T(state.T));
      ThermodynamicState bubbleState = setBubbleState(setSat_T(state.T));
      Real dr;
      Real drL;
      Real drG;
      Real etaL;
      Real etaG;
      Real Hc = 17.1045;
      Real Tr = state.T/T_crit;

      SaturationProperties sat = setSat_T(state.T);
      Real quality = if state.phase==2 then (bubbleState.d/state.d - 1)/
        (bubbleState.d/dewState.d - 1) else 1;
      Real phase_dT = if not ((state.d < bubbleDensity(sat) and state.d >
        dewDensity(sat)) and state.T < fluidConstants[1].criticalTemperature)
        then 1 else 2;

  algorithm
      if state.phase==1 or phase_dT==1 then
        eta := 0;
        dr := state.d/(d_crit*MM);
        for i in 1:11 loop
            eta := eta + nv[i]*Tr^tv[i]*dr^dv[i];
        end for;
        for i in 12:13 loop
            eta := eta + exp(-dr*dr/2)*nv[i]*Tr^tv[i]*dr^dv[i];
        end for;
        eta := (exp(eta) - 1)*Hc/1e6;
      elseif state.phase==2 or phase_dT==2 then
        etaL := 0;
        etaG := 0;
        drG := dewState.d/(d_crit*MM);
        drL := bubbleState.d/(d_crit*MM);
        for i in 1:11 loop
            etaL := etaL + nv[i]*Tr^tv[i]*drL^dv[i];
            etaG := etaG + nv[i]*Tr^tv[i]*drG^dv[i];
        end for;
        for i in 12:13 loop
            etaL := etaL + exp(-drL*drL/2)*nv[i]*Tr^tv[i]*drL^dv[i];
            etaG := etaG + exp(-drG*drG/2)*nv[i]*Tr^tv[i]*drG^dv[i];
        end for;
        etaL := (exp(etaL) - 1)*Hc/1e6;
        etaG := (exp(etaG) - 1)*Hc/1e6;
        eta := (quality/etaG + (1 - quality)/etaL)^(-1);
      end if;
  end dynamicViscosity;

  redeclare function extends thermalConductivity
  "Calculates thermal conductivity of refrigerant"

  protected
      Real B1[:] = {-3.51153e-2,1.70890e-1,-1.47688e-1,5.19283e-2,-6.18662e-3};
      Real B2[:] = {4.69195e-2,-1.48616e-1,1.32457e-1,-4.85636e-2,6.60414e-3};
      Real C[:] = {3.66486e-4,-2.21696e-3,2.64213e+0};
      Real A[:] = {-1.24778e-3,8.16371e-3,1.99374e-2};

      Real T_crit = fluidConstants[1].criticalTemperature;
      Real d_crit = fluidConstants[1].criticalMolarVolume;
      Real MM = fluidConstants[1].molarMass;

      Real delta = state.d/(d_crit*MM);
      Real deltaL = bubbleDensity(setSat_T(state.T))/(d_crit*MM);
      Real deltaG = dewDensity(setSat_T(state.T))/(d_crit*MM);
      Real tau = T_crit/state.T;

      Real quality = if state.phase==2 then (bubbleDensity(setSat_T(
        state.T))/state.d - 1)/(bubbleDensity(setSat_T(state.T))/
        dewDensity(setSat_T(state.T)) - 1) else 1;
      Real lambda0 = A[1]+A[2]/tau+A[3]/(tau^2);
      Real lambdar = 0;
      Real lambdarL = 0;
      Real lambdarG = 0;
      Real lambdaL = 0;
      Real lambdaG = 0;

      SaturationProperties sat = setSat_T(state.T);
      Real phase_dT = if not ((state.d < bubbleDensity(sat) and state.d >
        dewDensity(sat)) and state.T < fluidConstants[1].criticalTemperature)
        then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      for i in 1:5 loop
          lambdar := lambdar + (B1[i] + B2[i]/tau)*delta^i;
      end for;
      lambda := (lambda0 + lambdar + (C[1]/(C[2] + abs(1.0/tau - 1.0))*
        exp(-(C[3]*(delta - 1.0))^2)));
    elseif state.phase==2 or phase_dT==2 then
      for i in 1:5 loop
          lambdarL := lambdarL + (B1[i] + B2[i]/tau)*deltaL^i;
          lambdarG := lambdarG + (B1[i] + B2[i]/tau)*deltaG^i;
      end for;
      lambdaL := (lambda0 + lambdarL + (C[1]/(C[2] + abs(1.0/tau - 1.0))*
        exp(-(C[3]*(deltaL - 1.0))^2)));
      lambdaG := (lambda0 + lambdarG + (C[1]/(C[2] + abs(1.0/tau - 1.0))*
        exp(-(C[3]*(deltaG - 1.0))^2)));
      lambda := (quality/lambdaG + (1 - quality)/lambdaL)^(-1);
    end if;
  end thermalConductivity;

  redeclare function extends surfaceTension
  "Surface tension in two phase region of refrigerant"

  algorithm
    sigma := 1e-3*55.817*(1-sat.Tsat/369.85)^1.266;
  end surfaceTension;

  /*Provide functions to calculate further thermodynamic properties depending on
    the independent state properties. These functions are polynomial fits in 
    order to reduce computing time. Moreover, these functions may have a
    heuristic to deal with discontinuities. Add further fits if necessary.
  */
  redeclare function extends temperature_ph
  "Calculates temperature as function of pressure and specific enthalpy"
  protected
    SpecificEnthalpy dh = 10;
  end temperature_ph;

  redeclare function extends temperature_ps
  "Calculates temperature as function of pressure and specific entropy"
  protected
    SpecificEntropy ds = 10;
  end temperature_ps;

  redeclare function extends density_pT
  "Calculates density as function of pressure and temperature"
  protected
    AbsolutePressure dp = 10;
  end density_pT;

  redeclare function extends density_ph
  "Computes density as a function of pressure and enthalpy"
  protected
    SpecificEnthalpy dh = 10;
  end density_ph;

  redeclare function extends density_ps
  "Computes density as a function of pressure and entropy"
  protected
    SpecificEntropy ds = 50*p/(30e5-0.5e5);
  end density_ps;

  redeclare function extends specificEnthalpy_ps
  "Computes specific enthalpy as a function of pressure and entropy"
  protected
    SpecificEntropy ds = 100*p/(30e5-0.5e5);
  end specificEnthalpy_ps;

  redeclare function extends density_derh_p
  "Calculates density derivative (dd/dh)@p=const"
  protected
    AbsolutePressure dp = 0.2;
  end density_derh_p;

  annotation (Documentation(revisions="<html>
<ul>
  <li>
  June 12, 2017, by Mirko Engelpracht:<br/>
  First implementation (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/408\">issue 408</a>).
  </li>
</ul>
</html>", info="<html>
<p>This package provides a refrigerant model for R1270 using a hybrid approach developed by Sangi et al.. The hybrid approach is implemented in <a href=\"modelica://AixLib.Media.Refrigerants.Interfaces.PartialHybridTwoPhaseMedium\">AixLib.Media.Refrigerants.Interfaces.PartialHybridTwoPhaseMedium</a> and the refrigerant model is implemented by complete the template <a href=\"modelica://AixLib.Media.Refrigerants.Interfaces.TemplateHybridTwoPhaseMedium\">AixLib.Media.Refrigerants.Interfaces.TemplateHybridTwoPhaseMedium</a>. The fitting coefficients required in the template are saved in the package <a href=\"modelica://AixLib.DataBase.Media.Refrigerants.R1270\">AixLib.DataBase.Media.Refrigerants.R1270</a>.</p>
<p><b>Assumptions and limitations</b> </p>
<p>The implemented coefficients are fitted to external data by Sangi et al. and are valid within the following range:<br></p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\" width=\"30%\"><tr>
<td><p>Parameter</p></td>
<td><p>Minimum Value</p></td>
<td><p>Maximum Value</p></td>
</tr>
<tr>
<td><p>Pressure (p) in bar</p></td>
<td><p>0.5</p></td>
<td><p>30</p></td>
</tr>
<tr>
<td><p>Temperature (T) in K</p></td>
<td><p>263.15</p></td>
<td><p>343.15</p></td>
</tr>
</table>
<p><b>Validation</b> </p>
<p>Sangi et al. validated their model by comparing it to results obtained from the Helmholtz equation of state. They found out that relative error of the refrigerant model compared to HelmholtzMedia (Thorade and Saadat, 2012) is close to zero.</p>
<p><b>References</b> </p>
<p>Thorade, Matthis; Saadat, Ali (2012): <a href=\"http://www.ep.liu.se/ecp/076/006/ecp12076006.pdf\">HelmholtzMedia - A fluid properties library</a>. In: <i>Proceedings of the 9th International Modelica Conference</i>; September 3-5; 2012; Munich; Germany. Link&ouml;ping University Electronic Press, S. 63&ndash;70.</p>
<p>Sangi, Roozbeh; Jahangiri, Pooyan; Klasing, Freerk; Streblow, Rita; M&uuml;ller, Dirk (2014): <a href=\"http://dx.doi.org/10.3384/ecp14096\">A Medium Model for the Refrigerant Propane for Fast and Accurate Dynamic Simulations</a>. In: <i>The 10th International Modelica Conference</i>. Lund, Sweden, March 10-12, 2014: Link&ouml;ping University Electronic Press (Link&ouml;ping Electronic Conference Proceedings), S. 1271&ndash;1275</p>
<p>Klasing,Freerk: A New Design for Direct Exchange Geothermal Heat Pumps - Modeling, Simulation and Exergy Analysis. <i>Master thesis</i></p>
<p>Scalabrin, G.; Marchi, P.; Span, R. (2006): A Reference Multiparameter Viscosity Equation for Propane with an Optimized Functional Form. In: <i>J. Phys. Chem. Ref. Data, Vol. 35, No. 3</i>, S. 1415-1442</p>
</html>"));
end R1270_FastPropane;