package com.sirolf2009.music;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;


import jm.JMC;
import jm.music.data.*;
import jm.util.*;
import jm.music.tools.Mod;

public class SimpleGUI4 extends JFrame implements ActionListener, ChangeListener, JMC{
    private JButton composeBtn;
    private JSlider slider;
    private JLabel label;
    private int rootNote = C2;
    private int[] pattern = {0,0,4,7};
    private Part arpPart;
    private int counter = 0;
    private int arpLength = 4;
    
    
    public static void main(String[] args) {
        SimpleGUI4 gui = new SimpleGUI4();
    }
    
    public SimpleGUI4() {
        composeBtn = new JButton("Compose");
        composeBtn.addActionListener(this);
        JPanel panel = new JPanel();
        panel.add(composeBtn);
        slider = new JSlider(2, 8, 4);
        slider.addChangeListener(this);
        panel.add(slider);
        label = new JLabel("4");
        panel.add(label);
        this.getContentPane().add(panel);
        this.setSize(350, 60);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setVisible(true);
    }
    
    public void actionPerformed(ActionEvent ae){
        if (ae.getSource() == composeBtn) compose();
    }
    
    public void stateChanged(ChangeEvent ce) {
        if(ce.getSource() == slider) {
            arpLength = slider.getValue();
            label.setText("" + slider.getValue());
        }
    }
    
    public void compose() {
        Phrase phr = new Phrase();
        arpPart = new Part("Apreggio", SYNTH_BASS, 0);
        for(int i=0; i<arpLength; i++ ) {
            phr.addNote(new Note(rootNote + pattern[(int)(Math.random() * pattern.length)], EIGHTH_NOTE));
        }
        Mod.repeat(phr, 8);
        arpPart.addPhrase(phr);
        arpPart.setTempo(130.0);
        saveAndPlay();
    }

    public void saveAndPlay() {
        Write.midi(arpPart, "RnadomArp" + counter++ + ".mid");
        Play.midi(arpPart, false);
    }

}