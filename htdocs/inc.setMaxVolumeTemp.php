<!--
Maximum Volume Temp Select Form
-->
        <!-- input-group -->          
        <?php
        //$maxvolumetempvalue = exec("/usr/bin/sudo ".$conf['scripts_abs']."/playout_controls.sh -c=getmaxvolumetemp");
        //$maxvolumetempvalue = 43.6;//debug
        $maxvaluetempselect = round(($maxvolumetempvalue/5))*5;
        $maxvaluetempdisplay = round($maxvolumetempvalue);
        ?>
        <div class="col-md-4 col-sm-6">
            <div class="row" style="margin-bottom:1em;">
              <div class="col-xs-6">
              <h4><?php print $lang['settingsMaxVolTemp']; ?></h4>
                <form name='maxvolumetemp' method='post' action='<?php print $_SERVER['PHP_SELF']; ?>'>
                  <div class="input-group my-group">
                    <select id="maxvolumetemp" name="maxvolumetemp" class="selectpicker form-control">
                    <?php
                    $i = 100;
                    while ($i >= 5) {
                        print "
                        <option value='".$i."'";
                        if($maxvaluetempselect == $i) {
                            print " selected";
                        }
                        print ">".$i."%</option>";
                        $i = $i - 5;  
                    };
                    print "\n";
                    ?>
                    </select> 
                    <span class="input-group-btn">
                        <input type='submit' class="btn btn-default" name='submit' value='<?php print $lang['globalSet']; ?>'/>
                    </span>
                  </div>
                </form>
              </div>
              
              <div class="col-xs-6">
                  <div class="c100 p<?php print $maxvaluetempdisplay; ?>">
                    <span><?php print $maxvaluetempdisplay; ?>%</span>
                    <div class="slice">
                        <div class="bar"></div>
                        <div class="fill"></div>
                    </div>
                  </div> 
              </div>
            </div><!-- ./row -->
        </div>
        <!-- /input-group -->
