within AixLib.Fluid.Actuators.Valves.ExpansionValves.SimpleExpansionValves;
model IsothermalExpansionValve
  "Model of a simple isothermal expansion valve"
  extends BaseClasses.PartialIsothermalExpansionValve;

equation
  // Calculation of mass flow and pressure drop
  //
  if (calcProc == Utilities.Choices.CalcProc.linear) then
    C = 1  "Linear relationship";
    m_flow = C * AThr * dp
    "Simple linear relationship between mass flow and pressure drop";

  elseif (calcProc == Utilities.Choices.CalcProc.nominal) then
    C * dpNom = mFlowNom "Nominal relationship";
    m_flow = C * AThr * dp
    "Simple nominal relationship between mass flow and pressure drop";

  elseif (calcProc == Utilities.Choices.CalcProc.flowCoefficient) then
    C = flowCoefficient.C "Flow coefficient model";
    m_flow = homotopy(C * AThr * sqrt(2*dInl*dp),
                      mFlowNom/dpNom * AThr * dp)
    "Usage of flow coefficient model";

  else
    assert(false, "Invalid choice of calculation procedure");
  end if;

  annotation (Documentation(revisions="<html>
<ul>
  <li>
  October 16, 2017, by Mirko Engelpracht:<br/>
  First implementation
  (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/457\">issue 457</a>).
  </li>
</ul>
</html>"));
end IsothermalExpansionValve;