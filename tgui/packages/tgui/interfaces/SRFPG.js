import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const SRFPG = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window width={450} height={340} resizable>
      <Window.Content scrollable>
        {!!data.melted && <NoticeBox>Reactor Integrity Compromised.</NoticeBox>}
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Power switch">
              <Button
                icon={data.active ? 'power-off' : 'times'}
                onClick={() => act('toggle_power')}
                disabled={data.melted}
              >
                {data.active ? 'On' : 'Off'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Reactor Integrity">
              <ProgressBar
                value={data.integrity / 100}
                ranges={{
                  blue: [0.65, Infinity],
                  violet: [0.6, 0.65],
                  purple: [0.4, 0.6],
                  pink: [0.05, 0.4],
                  bad: [-Infinity, 0.05],
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Internal Heat">
              <ProgressBar
                value={data.heat / 100}
                ranges={{
                  pink: [0.95, Infinity],
                  red: [0.65, 0.95],
                  average: [0.55, 0.65],
                  olive: [0.4001, 0.55],
                  green: [0.2, 0.4001],
                  teal: [0.1, 0.2],
                  blue: [-Infinity, 0.1],
                }}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Output">
          <LabeledList>
            <LabeledList.Item label="Current output">
              {data.power_generated}
            </LabeledList.Item>
            <LabeledList.Item label="Power available">
              <Box inline color={!data.connected && 'bad'}>
                {data.connected ? data.power_available : 'Unconnected'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
