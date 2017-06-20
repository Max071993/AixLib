within AixLib.DataBase.Media.Refrigerants.R1270;
record TSP_Sangi
  "Record with fitting coefficients taken from the Fast_Propane model"
  import AixLib;
  extends
    AixLib.DataBase.Media.Refrigerants.ThermodynamicStatePropertiesBaseDataDefinition(
    name="Coefficients taken from FastPropane model developed by Sangi et al.",
    temperature_ph_nT={5,5,21,5,5,21},
    temperature_ph_sc={291.384236041825,-0.0704729863184529,20.5578417380748,-0.00678884566695906,
        0.136811720776647,-0.770247506716285,0.000202836611783306,-0.00447602797382070,
        0.0309332207143316,-0.0386472469260710,-9.71248676197528e-06,0.000273729410002939,
        -0.00177519423682889,0.00767135438646387,-0.00751600683912493,7.98267274869292e-07,
        -1.12691051342428e-05,0.000134930636679386,-0.000392485634748443,0.00140205757787774,
        -0.00163000559967510},
    temperature_ph_sh={308.060027778396,6.59039876392094,20.7950243141380,0.0453108439023189,
        -1.43969687581506,-0.411365889418558,0.00540769150996739,-0.0188305448625778,0.255977908649908,
        -0.00497446957449581,-0.000196566506959251,-0.00847992074678385,0.00660309588666398,
        -0.0432200997543392,0.00465132954244280,-4.64422678045603e-05,0.000787074643540945,
        0.00281445602040784,-0.00176606807260317,0.00590025752789791,-0.000577281104194347},
    temperature_ph_iO={1682457.51267010,247137.397786416,720642.233056887,54003.5903158973,
        382099.574228781,639399.497939419,403596.556578661,37200.2691858212},
    temperature_ps_nT={5,5,21,5,5,21},
    temperature_ps_sc={290.574168937952,0.490828546245446,19.8608752914032,0.117871744016533,
        0.130154107880201,-0.0408172235661160,0.0181671755438826,0.0292848788419663,0.0324083687227166,
        -0.0857625427384498,0.00191602988674819,0.00377150163705040,0.00622225803519055,
        0.00799217399325639,-0.0124017661200968,0.000114975996621020,0.000243666235393007,
        0.000459514035453056,0.000907175802732240,0.00127247920370296,-0.00192723964571896},
    temperature_ps_sh={305.667994209752,34.3546579581206,36.3220486736092,0.956829304294540,
        0.239229453753890,0.702977715170277,0.129780738468536,-0.303362575167080,0.000814283563881690,
        -0.100508863694088,0.0577060502424694,-0.0264862744961215,0.0826586807740864,-0.00125351482775024,
        0.0160903628800248,0.0132124973316544,-0.00720862103838031,0.00736011556482272,
        -0.00773556171071259,0.00365836572791750,-0.000494569833066580},
    temperature_ps_iO={14.225189003160570,1.152465068418020e+03,0.499169296800688,1.792997138404026e+02,
        12.3876547448383,2715.65359560750,0.961902709412239,207.473158311391},
    density_pT_nT={5,5,21,5,5,21},
    density_pT_sc={6.99012116216078,7.85762798977443,-0.618509525341628,0.561456406237816,
        -0.827135398454184,0.0644646531072409,0.0745135118619033,-0.227438027200113,0.113487112138254,
        -0.00894774750115025,0.0141066470211284,-0.0614336770277778,0.0715858695051831,
        -0.0210652010997730,0.00116677386847406,0.00292620516208197,-0.0165506988456200,
        0.0269207717408464,-0.0137994983041971,0.00162333280148309,-2.13433530006928e-05},
    density_pT_sh={506.208387981876,1.87054256217980,-29.9062841232497,-0.0351624357762205,
        0.693501535440458,-2.21393734916457,0.00126962771607607,-0.0298496253585084,0.222243208624831,
        -0.419234944193293,7.69903677841526e-06,0.00219916470789359,-0.0156164603769147,
        0.0699901864638379,-0.104815271970145,1.34663813731525e-05,1.90380071619604e-06,
        0.00117322708291575,-0.00424731659901982,0.0141806356166424,-0.0227711391125435},
    density_pT_iO={382099.574228781,307.564799259815,403596.556578661,22.5879133275781,
        1682457.51267010,290.645659315997,720642.233056887,19.9347318052857});

  annotation (Documentation(revisions="<html>
<ul>
  <li>
  June 10, 2017, by Mirko Engelpracht:<br/>
  First implementation (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/408\">issue 408</a>).
  </li>
</ul>
</html>", info="<html>
<p>In this record, fitting coefficients are provided for thermodynamic properties calculated from two independent state variables. For detailed information of these thermodynamic properties as well as the fitting coefficients, please checkout <a href=\"modelica://AixLib.DataBase.Media.Refrigerants.ThermodynamicStatePropertiesBaseDataDefinition\">AixLib.DataBase.Media.Refrigerants.ThermodynamicStatePropertiesBaseDataDefinition</a>. The fitting coefficients are used in a hybrid refrigerant model provided in <a href=\"modelica://AixLib.Media.Refrigerants\">AixLib.Media.Refrigerants</a>. For detailed information, please checkout <a href=\"modelica://AixLib.Media.Refrigerants.Interfaces.TemplateHybridTwoPhaseMedium\">AixLib.Media.Refrigerants.Interfaces.TemplateHybridTwoPhaseMedium</a>.</p>
<p><b>Assumptions and limitations</b></p>
<p>The provided coefficients are fitted to external data by Sangi et al. and are valid within the following range:<br></p>
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
<p><b>References</b></p>
<p>Sangi, Roozbeh; Jahangiri, Pooyan; Klasing, Freerk; Streblow, Rita; M&uuml;ller, Dirk (2014): <a href=\"http://dx.doi.org/10.3384/ecp14096\">A Medium Model for the Refrigerant Propane for Fast and Accurate Dynamic Simulations</a>. In: <i>The 10th International Modelica Conference</i>. Lund, Sweden, March 10-12, 2014: Link&ouml;ping University Electronic Press (Link&ouml;ping Electronic Conference Proceedings), S. 1271&ndash;1275</p>
</html>"));
end TSP_Sangi;