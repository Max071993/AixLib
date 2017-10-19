within AixLib.Fluid.Actuators.ExpansionValves.ModularExpansionValves;
model ModularExpansionValvesSensors
  "Model of modular expansion valves, i.g. each valves is in front 
  of an evaporator, combined with sensors"
  extends BaseClasses.PartialModularExpansionVavles;

  // Definition of parameters
  //
  parameter Modelica.SIunits.Time tau = 1
    "Time constant at nominal flow rate"
    annotation(Dialog(tab="Sensors",group="General"),
               HideResult=not show_parSen);

  parameter Boolean transferHeat = false
    "if true, temperature T converges towards TAmb when no flow"
    annotation(Dialog(tab="Sensors",group="General"),
               HideResult=not show_parSen);
  parameter Modelica.SIunits.Temperature TAmb = Medium.T_default
    "Fixed ambient temperature for heat transfer"
    annotation(Dialog(tab="Sensors",group="Temperature sensors"),
               HideResult=not show_parSen);
  parameter Modelica.SIunits.Time tauHeaTra = 1200
    "Time constant for heat transfer, default 20 minutes"
    annotation(Dialog(tab="Sensors",group="Temperature sensors"),
               HideResult=not show_parSen);

  parameter Modelica.SIunits.Temperature T_start = Medium.T_default
    "Initial or guess value of output (= state)"
    annotation(Dialog(tab="Advanced",group="Initialisation Sensors"),
               HideResult=not show_parSen);
  parameter Modelica.SIunits.SpecificEnthalpy h_out_start=
      Medium.specificEnthalpy_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
      "Initial or guess value of output (= state)"
    annotation(Dialog(tab="Advanced",group="Initialisation Sensors"),
               HideResult=not show_parSen);
  parameter Modelica.Blocks.Types.Init initTypeSen=
    Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
    annotation(Dialog(tab="Advanced",group="Initialisation Sensors"),
               HideResult=not show_parSen);

  parameter Boolean show_parSen = false
    "= true, if sensors' input parameters are shown in results"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  // Definition of models
  //
  Utilities.ModularSensors modularSensors(
    redeclare final package Medium = Medium,
    final nPorts=nVal,
    final dp_start=dp_start,
    final m_flow_start=m_flow_start,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=1e-6*m_flow_nominal,
    final tau=tau,
    final transferHeat=transferHeat,
    final TAmb=TAmb,
    final tauHeaTra=tauHeaTra,
    final initType=initTypeSen,
    final T_start=T_start,
    final h_out_start=h_out_start)
    "Model that contains different sensors located behind expansion valves"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));


equation
  // Connect expansion valves with sensors and sensors with ports_b
  //
  for i in 1:nVal loop
    connect(expansionValves[i].port_b,modularSensors.ports_a[i]);
    connect(modularSensors.ports_b[i],ports_b[i]);
  end for;

  // Connect sensors with data bus
  //
  connect(modularSensors.preMea, dataBus.senPreValve)
    annotation (Line(points={{34,-10},{34,-90},{0.05,-90},{0.05,-99.95}},
                color={0,0,127}));
  connect(modularSensors.temMea, dataBus.senTemValve)
    annotation (Line(points={{38,-10},{38,-90},{0.05,-90},{0.05,-99.95}},
                color={0,0,127}));
  connect(modularSensors.masFloMea, dataBus.senMasFloValve)
    annotation (Line(points={{42,-10},{42,-90},{0.05,-90},{0.05,-99.95}},
                color={0,0,127}));
  connect(modularSensors.quaMea, dataBus.senPhaValve)
    annotation (Line(points={{46,-10},{46,-10},{46,-20},{46,-90},
                {0.05,-90},{0.05,-99.95}},
                color={0,0,127}));

end ModularExpansionValvesSensors;