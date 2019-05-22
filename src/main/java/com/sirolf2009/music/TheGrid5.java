package com.sirolf2009.music;

import jm.JMC;
import jm.music.data.*;
import jm.util.*;

import java.awt.*;
import javax.swing.*;
import java.awt.event.*;

// Add labels and grid numbers
// Centre the JCheckBoxes and JLabels so they align
// Manage the user interactions for check boxes and buttons - listeners
// Add some comments

public class TheGrid5 implements JMC, ItemListener, ActionListener {
    private Phrase hats, snare, kick;
    private Part drums;
    private JCheckBox[] hatTicks, snareTicks, kickTicks;
    private JButton saveBtn, playBtn;
    
    public static void main(String[] args) {
        TheGrid5 gg = new TheGrid5();
    }
    
    /**
    * Constructor. Sets up the parameters.
    */
    public TheGrid5() {
        hats = new Phrase(0.0);
        snare = new Phrase(0.0);
        kick = new Phrase(0.0);
        drums = new Part("Drums", 25, 9);
        drums.addPhrase(hats);
        drums.addPhrase(snare);
        drums.addPhrase(kick);
        // set look and feel
        String local = javax.swing.UIManager.getSystemLookAndFeelClassName();
        String metal = javax.swing.UIManager.getCrossPlatformLookAndFeelClassName();
        try {
            UIManager.setLookAndFeel(metal); // use local or metal
        } catch (Exception e) {}
        // set graphic data
        hatTicks = new JCheckBox[16];
        snareTicks = new JCheckBox[16];
        kickTicks = new JCheckBox[16];
        // call other methods
        compose();
        makeInterface();
                       
    }
    /**
    * Do the real musical work
    */
    public void compose() {
         int[] hatsHits = 
            {REST, REST, FS2, REST, REST, REST, FS2, REST, REST, REST, FS2, REST, REST, REST, FS2, REST,};
        hats.addNoteList(hatsHits, SIXTEENTH_NOTE);
        int[] snareHits = 
            {REST, REST, REST, REST, D2, REST, REST, REST, REST, REST, REST, REST, D2, REST, D2, REST};
        snare.addNoteList(snareHits, SIXTEENTH_NOTE);
        int[] kickHits = 
            {C2, REST, REST, REST, REST, REST, REST, C2, C2, REST, REST, REST, REST, REST, REST, REST};
        kick.addNoteList(kickHits, SIXTEENTH_NOTE);
    }
    
    /**
    * GUI code
    */
    private void makeInterface() {
        JFrame window = new JFrame("Drum pattern");
        window.getContentPane().setLayout(new GridLayout(5,1));
        // numbers
        JPanel numbGrid = new JPanel(new GridLayout(1,16));
        numbGrid.setPreferredSize(new Dimension(400, 20));
        for (int i=1; i<17; i++) {
            numbGrid.add(new JLabel(""+i, SwingConstants.CENTER));
        }
        window.getContentPane().add(numbGrid);
        // hats
        JPanel grid = new JPanel(new GridLayout(1,16));
        for (int i=0; i<16; i++) {
            JCheckBox tick = new JCheckBox();
            tick.addItemListener(this);
            tick.setHorizontalAlignment(SwingConstants.CENTER);
            if(hats.getNote(i).getPitch() != REST) tick.setSelected(true);
            grid.add(tick);
            hatTicks[i] = tick;
        }
        window.getContentPane().add(grid);
        // snare
        JPanel grid2 = new JPanel(new GridLayout(1,16));
        for (int i=0; i<16; i++) {
            JCheckBox tick = new JCheckBox();
            tick.addItemListener(this);
            tick.setHorizontalAlignment(SwingConstants.CENTER);
            if(snare.getNote(i).getPitch() != REST) tick.setSelected(true);
            grid2.add(tick);
            snareTicks[i] = tick;
        }
        window.getContentPane().add(grid2);
        // kick
        JPanel grid3 = new JPanel(new GridLayout(1,16));
        for (int i=0; i<16; i++) {
            JCheckBox tick = new JCheckBox();
            tick.addItemListener(this);
            tick.setHorizontalAlignment(SwingConstants.CENTER);
            if(kick.getNote(i).getPitch() != REST) tick.setSelected(true);
            grid3.add(tick);
            kickTicks[i] = tick;
        }
        window.getContentPane().add(grid3);
        
        JPanel btnPanel = new JPanel();
        //  buttons
        playBtn = new JButton("Play");
        playBtn.addActionListener(this);
        btnPanel.add(playBtn);
        saveBtn = new JButton("Save MIDI file");
        saveBtn.addActionListener(this);
        btnPanel.add(saveBtn);
        window.getContentPane().add(btnPanel);
        
        window.pack();
        window.setVisible(true);
    }
    
    /**
    * Handle the checkbox clicks
    */
    public void itemStateChanged(ItemEvent e) {
        for(int i=0; i<16; i++) {
            if(e.getSource() == hatTicks[i]) {
                if(hatTicks[i].isSelected()) hats.getNote(i).setPitch(FS2);
                else hats.getNote(i).setPitch(REST);
                return;
            } else
            if(e.getSource() == snareTicks[i]) {
                if(snareTicks[i].isSelected()) snare.getNote(i).setPitch(D2);
                else snare.getNote(i).setPitch(REST);
                return;
            } else
            if(e.getSource() == kickTicks[i]) {
                if(kickTicks[i].isSelected()) kick.getNote(i).setPitch(C2);
                else kick.getNote(i).setPitch(REST);
                return;
            }
        }
    }
    
    /**
    * Handle the button clicks
    */
    public void actionPerformed(ActionEvent e) {
        if(e.getSource() == playBtn) play();
        if(e.getSource() == saveBtn) saveFile();
    }
    
    /**
    * Write the music to a MIDI file
    */
     private void saveFile() {
        Write.midi(drums, "DrumPattern5.mid");
    }
    
    /**
    * Play back the music
    */
    private void play() {
        Play.midi(drums, false);
    }

}